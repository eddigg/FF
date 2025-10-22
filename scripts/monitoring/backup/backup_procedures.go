package main

import (
	"archive/tar"
	"compress/gzip"
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"

	"atlas-blockchain/pkg/storage"
)

// BackupManager handles backup and recovery operations
type BackupManager struct {
	config        *BackupConfig
	storage       *storage.DistributedStorage
	backupStorage *storage.BackupStorage
	notifier      NotificationService
}

// BackupConfig holds backup configuration
type BackupConfig struct {
	BackupFrequency    time.Duration         `json:"backup_frequency"`
	RetentionPeriod    time.Duration         `json:"retention_period"`
	MaxBackupSize      int64                 `json:"max_backup_size_gb"` // in GB
	MaxFileSize        int64                 `json:"max_file_size"`      // max individual file size
	CompressionLevel   int                  `json:"compression_level"`
	EncryptionEnabled  bool                 `json:"encryption_enabled"`
	TestRestoresEnabled bool                `json:"test_restores_enabled"`
	Paths              []BackupPath          `json:"paths"`
	NotificationConfig *NotificationConfig   `json:"notification_config"`
}

type BackupPath struct {
	Path         string   `json:"path"`
	Type         string   `json:"type"` // "blockchain", "analytics", "config", "logs"
	Includes     []string `json:"includes,omitempty"`
	Excludes     []string `json:"excludes,omitempty"`
	Priority     int      `json:"priority"` // 1-10, higher = more important
}

type BackupMetadata struct {
	ID                 string            `json:"id"`
	Type               string            `json:"type"`
	CreatedAt          time.Time         `json:"created_at"`
	Size               int64             `json:"size"`
	Checksum           string            `json:"checksum"`
	CompressedSize     int64             `json:"compressed_size"`
	EncryptionKeyID    string            `json:"encryption_key_id,omitempty"`
	Paths              []BackupPath      `json:"paths"`
	Status             string            `json:"status"` // "in_progress", "completed", "failed"
	ErrorMessage       string            `json:"error_message,omitempty"`
	RestoreTimeSeconds int               `json:"restore_time_seconds,omitempty"`
}

type BackupResult struct {
	BackupID       string        `json:"backup_id"`
	Success        bool          `json:"success"`
	Size           int64         `json:"size"`
	Duration       time.Duration `json:"duration"`
	ErrorMessage   string        `json:"error_message,omitempty"`
}

type RecoveryResult struct {
	BackupID       string        `json:"backup_id"`
	Success        bool          `json:"success"`
	FilesRestored  int           `json:"files_restored"`
	DataRestored   int64         `json:"data_restored"`
	Duration       time.Duration `json:"duration"`
	ErrorMessage   string        `json:"error_message,omitempty"`
}

// NewBackupManager creates a new backup manager
func NewBackupManager(config *BackupConfig, storage *storage.DistributedStorage) *BackupManager {
	return &BackupManager{
		config:        config,
		storage:       storage,
		backupStorage: storage.NewBackupStorage(),
	}
}

// ScheduleBackups sets up automated backup scheduling
func (bm *BackupManager) ScheduleBackups(ctx context.Context) {
	go func() {
		ticker := time.NewTicker(bm.config.BackupFrequency)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				bm.performScheduledBackup(ctx)
			case <-ctx.Done():
				return
			}
		}
	}()
}

// performScheduledBackup creates automated backup
func (bm *BackupManager) performScheduledBackup(ctx context.Context) {
	log.Println("🔄 Starting scheduled backup...")

	result := bm.CreateFullBackup(ctx, "scheduled")

	if result.Success {
		log.Printf("✅ Scheduled backup completed successfully: %s", result.BackupID)

		// Clean up old backups
		bm.cleanupOldBackups()

		// Notify success
		bm.notifyBackupResult(result, "scheduled")
	} else {
		log.Printf("❌ Scheduled backup failed: %s", result.ErrorMessage)

		// Notify failure
		bm.notifyBackupResult(result, "scheduled")
	}
}

// CreateFullBackup creates a complete system backup
func (bm *BackupManager) CreateFullBackup(ctx context.Context, trigger string) *BackupResult {
	startTime := time.Now()
	backupID := fmt.Sprintf("backup_%d_%s", time.Now().Unix(), trigger)

	log.Printf("🔄 Starting full backup: %s", backupID)

	// Create backup metadata
	metadata := &BackupMetadata{
		ID:               backupID,
		Type:             "full",
		CreatedAt:        startTime,
		Status:           "in_progress",
		Paths:            bm.config.Paths,
	}

	// Save initial metadata
	if err := bm.backupStorage.SaveBackupMetadata(backupID, metadata); err != nil {
		return &BackupResult{
			BackupID:     backupID,
			Success:      false,
			Duration:     time.Since(startTime),
			ErrorMessage: fmt.Sprintf("Failed to save metadata: %v", err),
		}
	}

	var totalSize int64
	var errors []error

	// Backup each path
	for _, backupPath := range bm.config.Paths {
		if ctx.Err() != nil {
			break
		}

		result := bm.backupPath(backupID, backupPath)
		if result.Success {
			totalSize += result.Size
		} else {
			errors = append(errors, fmt.Errorf("Failed to backup %s: %s", backupPath.Path, result.ErrorMessage))
		}
	}

	// Create compressed archive
	archiveResult := bm.createCompressedArchive(backupID, bm.config.Paths)
	if !archiveResult.Success {
		return &BackupResult{
			BackupID:     backupID,
			Success:      false,
			Duration:     time.Since(startTime),
			ErrorMessage: fmt.Sprintf("Archive creation failed: %s", archiveResult.ErrorMessage),
		}
	}

	// Update metadata
	metadata.Status = "completed"
	metadata.Size = totalSize
	metadata.CompressedSize = archiveResult.Size
	metadata.RestoreTimeSeconds = 0 // Will be set on restore test

	if len(errors) > 0 {
		metadata.ErrorMessage = fmt.Sprintf("%d errors occurred: %v", len(errors), errors)
	}

	if err := bm.backupStorage.SaveBackupMetadata(backupID, metadata); err != nil {
		log.Printf("⚠️  Failed to update backup metadata: %v", err)
	}

	duration := time.Since(startTime)

	// Test restore if configured
	if bm.config.TestRestoresEnabled {
		bm.testRestore(backupID)
	}

	return &BackupResult{
		BackupID: backupID,
		Success:  len(errors) == 0,
		Size:     totalSize,
		Duration: duration,
	}
}

// backupPath backs up a specific path
func (bm *BackupManager) backupPath(backupID string, backupPath BackupPath) *PathBackupResult {
	var totalSize int64
	var fileCount int

	err := filepath.Walk(backupPath.Path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Check if file should be excluded
		if bm.shouldExcludeFile(path, backupPath.Excludes) {
			if info.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}

		// Check if file should be included
		if !bm.shouldIncludeFile(path, backupPath.Includes) {
			return nil
		}

		// Only backup regular files for now
		if !info.Mode().IsRegular() {
			return nil
		}

		// Check file size limits
		if info.Size() > bm.config.MaxFileSize {
			log.Printf("⚠️  Skipping large file: %s (%d bytes)", path, info.Size())
			return nil
		}

		// Backup file
		if err := bm.backupFile(backupID, path, backupPath); err != nil {
			log.Printf("❌ Failed to backup file %s: %v", path, err)
			return nil
		}

		totalSize += info.Size()
		fileCount++

		return nil
	})

	if err != nil {
		return &PathBackupResult{
			Success:      false,
			Size:         totalSize,
			FileCount:    fileCount,
			ErrorMessage: err.Error(),
		}
	}

	return &PathBackupResult{
		Success:   true,
		Size:      totalSize,
		FileCount: fileCount,
	}
}

type PathBackupResult struct {
	Success      bool   `json:"success"`
	Size         int64  `json:"size"`
	FileCount    int    `json:"file_count"`
	ErrorMessage string `json:"error_message,omitempty"`
}

// backupFile backs up an individual file
func (bm *BackupManager) backupFile(backupID, filePath string, backupPath BackupPath) error {
	sourceFile, err := os.Open(filePath)
	if err != nil {
		return err
	}
	defer sourceFile.Close()

	backupKey := fmt.Sprintf("backup/%s/%s", backupID, bm.getRelativePath(filePath, backupPath.Path))
	return bm.backupStorage.StoreFile(backupKey, sourceFile)
}

// createCompressedArchive creates a compressed archive of all backup data
func (bm *BackupManager) createCompressedArchive(backupID string, paths []BackupPath) *ArchiveResult {
	archivePath := fmt.Sprintf("/tmp/backup_%s.tar.gz", backupID)

	file, err := os.Create(archivePath)
	if err != nil {
		return &ArchiveResult{Success: false, ErrorMessage: err.Error()}
	}
	defer file.Close()

	gzipWriter := gzip.NewWriter(file)
	defer gzipWriter.Close()

	tarWriter := tar.NewWriter(gzipWriter)
	defer tarWriter.Close()

	var totalSize int64

	for _, backupPath := range paths {
		err = filepath.Walk(backupPath.Path, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			// Skip excluded files
			if bm.shouldExcludeFile(path, backupPath.Excludes) {
				if info.IsDir() {
					return filepath.SkipDir
				}
				return nil
			}

			if !bm.shouldIncludeFile(path, backupPath.Includes) {
				return nil
			}

			if !info.Mode().IsRegular() {
				return nil
			}

			return bm.addFileToArchive(tarWriter, path, backupPath.Path, &totalSize)
		})

		if err != nil {
			return &ArchiveResult{Success: false, ErrorMessage: err.Error()}
		}
	}

	return &ArchiveResult{Success: true, ArchivePath: archivePath, Size: totalSize}
}

type ArchiveResult struct {
	Success      bool   `json:"success"`
	ArchivePath  string `json:"archive_path"`
	Size         int64  `json:"size"`
	ErrorMessage string `json:"error_message,omitempty"`
}

func (bm *BackupManager) addFileToArchive(tarWriter *tar.Writer, filePath, basePath string, totalSize *int64) error {
	file, err := os.Open(filePath)
	if err != nil {
		return err
	}
	defer file.Close()

	stat, err := file.Stat()
	if err != nil {
		return err
	}

	*totalSize += stat.Size()

	header := &tar.Header{
		Name:    bm.getRelativePath(filePath, basePath),
		Size:    stat.Size(),
		Mode:    int64(stat.Mode()),
		ModTime: stat.ModTime(),
	}

	if err := tarWriter.WriteHeader(header); err != nil {
		return err
	}

	_, err = io.Copy(tarWriter, file)
	return err
}

// RestoreFromBackup restores data from a backup
func (bm *BackupManager) RestoreFromBackup(ctx context.Context, backupID, targetPath string) *RecoveryResult {
	startTime := time.Now()

	log.Printf("🔄 Starting restore from backup: %s", backupID)

	// Load backup metadata
	metadata, err := bm.backupStorage.GetBackupMetadata(backupID)
	if err != nil {
		return &RecoveryResult{
			BackupID:     backupID,
			Success:      false,
			Duration:     time.Since(startTime),
			ErrorMessage: fmt.Sprintf("Failed to load backup metadata: %v", err),
		}
	}

	// Ensure target directory exists
	if err := os.MkdirAll(targetPath, 0755); err != nil {
		return &RecoveryResult{
			BackupID:     backupID,
			Success:      false,
			Duration:     time.Since(startTime),
			ErrorMessage: fmt.Sprintf("Failed to create target directory: %v", err),
		}
	}

	var filesRestored int
	var dataRestored int64

	// Restore each path
	for _, backupPath := range metadata.Paths {
		if ctx.Err() != nil {
			break
		}

		result := bm.restorePath(backupID, backupPath, targetPath)
		filesRestored += result.FilesRestored
		dataRestored += result.DataRestored

		if !result.Success {
			log.Printf("❌ Failed to restore path %s: %s", backupPath.Path, result.ErrorMessage)
		}
	}

	// Update metadata with restore time
	metadata.RestoreTimeSeconds = int(time.Since(startTime).Seconds())
	if err := bm.backupStorage.SaveBackupMetadata(backupID, metadata); err != nil {
		log.Printf("⚠️  Failed to update restore metadata: %v", err)
	}

	duration := time.Since(startTime)

	success := filesRestored > 0
	if !success {
		return &RecoveryResult{
			BackupID:     backupID,
			Success:      false,
			Duration:     duration,
			ErrorMessage: "No files were restored",
		}
	}

	log.Printf("✅ Restore completed: %d files, %d bytes", filesRestored, dataRestored)

	return &RecoveryResult{
		BackupID:      backupID,
		Success:       true,
		FilesRestored: filesRestored,
		DataRestored:  dataRestored,
		Duration:      duration,
	}
}

func (bm *BackupManager) restorePath(backupID string, backupPath BackupPath, targetPath string) *RestorePathResult {
	var filesRestored int
	var dataRestored int64

	// Get all files for this backup and path
	prefix := fmt.Sprintf("backup/%s/%s", backupID, backupPath.Type)

	files, err := bm.backupStorage.ListFiles(prefix)
	if err != nil {
		return &RestorePathResult{
			Success:      false,
			ErrorMessage: err.Error(),
		}
	}

	for _, fileKey := range files {
		// Extract relative path from key
		relativePath := strings.TrimPrefix(fileKey, prefix+"/")

		targetFilePath := filepath.Join(targetPath, relativePath)

		// Create directory if needed
		dir := filepath.Dir(targetFilePath)
		if err := os.MkdirAll(dir, 0755); err != nil {
			log.Printf("⚠️  Failed to create directory %s: %v", dir, err)
			continue
		}

		// Restore file
		file, err := bm.backupStorage.GetFile(fileKey)
		if err != nil {
			log.Printf("⚠️  Failed to get file %s: %v", fileKey, err)
			continue
		}

		targetFile, err := os.Create(targetFilePath)
		if err != nil {
			file.Close()
			log.Printf("⚠️  Failed to create file %s: %v", targetFilePath, err)
			continue
		}

		size, err := io.Copy(targetFile, file)
		targetFile.Close()
		file.Close()

		if err != nil {
			log.Printf("⚠️  Failed to write file %s: %v", targetFilePath, err)
			continue
		}

		filesRestored++
		dataRestored += size

		// Set original permissions if possible
		// This would require storing permissions in backup metadata
	}

	return &RestorePathResult{
		Success:       true,
		FilesRestored: filesRestored,
		DataRestored:  dataRestored,
	}
}

type RestorePathResult struct {
	Success       bool   `json:"success"`
	FilesRestored int    `json:"files_restored"`
	DataRestored  int64  `json:"data_restored"`
	ErrorMessage  string `json:"error_message,omitempty"`
}

// ListBackups returns list of available backups
func (bm *BackupManager) ListBackups() ([]BackupMetadata, error) {
	return bm.backupStorage.ListBackups()
}

// cleanupOldBackups removes backups older than retention period
func (bm *BackupManager) cleanupOldBackups() {
	backups, err := bm.ListBackups()
	if err != nil {
		log.Printf("❌ Failed to list backups for cleanup: %v", err)
		return
	}

	cutoff := time.Now().Add(-bm.config.RetentionPeriod)
	var toDelete []string

	for _, backup := range backups {
		if backup.CreatedAt.Before(cutoff) {
			toDelete = append(toDelete, backup.ID)
		}
	}

	for _, backupID := range toDelete {
		if err := bm.DeleteBackup(backupID); err != nil {
			log.Printf("❌ Failed to delete old backup %s: %v", backupID, err)
		} else {
			log.Printf("🗑️  Deleted old backup: %s", backupID)
		}
	}
}

// DeleteBackup deletes a backup
func (bm *BackupManager) DeleteBackup(backupID string) error {
	// Delete all files for this backup
	prefix := fmt.Sprintf("backup/%s/", backupID)

	files, err := bm.backupStorage.ListFiles(prefix)
	if err != nil {
		return err
	}

	for _, file := range files {
		if err := bm.backupStorage.DeleteFile(file); err != nil {
			log.Printf("⚠️  Failed to delete backup file %s: %v", file, err)
		}
	}

	// Delete metadata
	return bm.backupStorage.DeleteBackupMetadata(backupID)
}

// testRestore performs a test restore to verify backup integrity
func (bm *BackupManager) testRestore(backupID string) {
	log.Printf("🧪 Testing restore for backup: %s", backupID)

	tempDir, err := os.MkdirTemp("", "backup_test_*")
	if err != nil {
		log.Printf("⚠️  Failed to create temp directory for restore test: %v", err)
		return
	}
	defer os.RemoveAll(tempDir)

	testResult := bm.RestoreFromBackup(context.Background(), backupID, tempDir)

	if testResult.Success {
		log.Printf("✅ Restore test passed: %d files, %d bytes in %v",
			testResult.FilesRestored, testResult.DataRestored, testResult.Duration)
	} else {
		log.Printf("❌ Restore test failed: %s", testResult.ErrorMessage)
	}
}

// Utility functions

func (bm *BackupManager) shouldExcludeFile(path string, excludes []string) bool {
	for _, exclude := range excludes {
		matched, _ := filepath.Match(exclude, filepath.Base(path))
		if matched {
			return true
		}
	}
	return false
}

func (bm *BackupManager) shouldIncludeFile(path string, includes []string) bool {
	if len(includes) == 0 {
		return true
	}

	for _, include := range includes {
		matched, _ := filepath.Match(include, filepath.Base(path))
		if matched {
			return true
		}
	}
	return false
}

func (bm *BackupManager) getRelativePath(fullPath, basePath string) string {
	rel, err := filepath.Rel(basePath, fullPath)
	if err != nil {
		return fullPath
	}
	return rel
}

func (bm *BackupManager) notifyBackupResult(result *BackupResult, trigger string) {
	if bm.notifier == nil {
		return
	}

	message := fmt.Sprintf("Backup %s: %s (%d bytes in %v)",
		trigger, result.Success ? "SUCCESS" : "FAILED",
		result.Size, result.Duration)

	if !result.Success {
		message += fmt.Sprintf("\nError: %s", result.ErrorMessage)
	}

	bm.notifier.SendNotification("Backup", message,
		result.Success ? "success" : "error")
}

// DefaultBackupConfig returns a default backup configuration
func DefaultBackupConfig() *BackupConfig {
	return &BackupConfig{
		BackupFrequency:    24 * time.Hour,
		RetentionPeriod:    30 * 24 * time.Hour, // 30 days
		MaxBackupSize:      100 * 1024 * 1024 * 1024, // 100GB in bytes
		MaxFileSize:        1 * 1024 * 1024 * 1024,   // 1GB max file size
		CompressionLevel:   6,
		EncryptionEnabled:  true,
		TestRestoresEnabled: true,
		Paths: []BackupPath{
			{
				Path:     "products/blockchain/core",
				Type:     "blockchain",
				Includes: []string{"*.db", "*.json", "*.log"},
				Priority: 10,
			},
			{
				Path:     "operations/monitoring",
				Type:     "monitoring",
				Includes: []string{"*.db", "*.log", "*.json"},
				Priority: 8,
			},
			{
				Path:     "data/analytics",
				Type:     "analytics",
				Priority: 7,
			},
			{
				Path:     "data/blockchain",
				Type:     "blockchain_data",
				Priority: 9,
			},
		},
		NotificationConfig: &NotificationConfig{
			EmailEnabled:  true,
			SlackEnabled:  true,
			EmailTo:       []string{"ops@atlas.io"},
			SlackChannel:  "#backups",
		},
	}
}

type NotificationConfig struct {
	EmailEnabled  bool     `json:"email_enabled"`
	SlackEnabled  bool     `json:"slack_enabled"`
	EmailTo       []string `json:"email_to"`
	SlackChannel  string   `json:"slack_channel"`
}

type NotificationService interface {
	SendNotification(title, message, level string) error
}
