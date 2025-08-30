package social

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sort"
	"strings"
	"time"
	"atlas-blockchain/internal/identity"
)

// SocialManager handles all social media operations
type SocialManager struct {
	posts           map[string]*Post
	comments        map[string]*Comment
	likes           map[string]*Like
	feeds           map[string]*Feed
	moderation      *ContentModerator
	trending        *TrendingManager
	hashtags        map[string]*Hashtag
	mentions        map[string][]string
	reports         map[string]*Report
	identityManager *identity.IdentityManager
}

// Post represents a social media post
type Post struct {
	ID          string                 `json:"id"`
	Author      string                 `json:"author"`
	Content     string                 `json:"content"`
	MediaURLs   []string               `json:"media_urls,omitempty"`
	Hashtags    []string               `json:"hashtags,omitempty"`
	Mentions    []string               `json:"mentions,omitempty"`
	Visibility  string                 `json:"visibility"` // "public", "friends", "private"
	Category    string                 `json:"category"`   // "general", "commerce", "governance"
	Likes       int64                  `json:"likes"`
	Comments    int64                  `json:"comments"`
	Shares      int64                  `json:"shares"`
	Views       int64                  `json:"views"`
	Status      string                 `json:"status"` // "active", "hidden", "deleted", "moderated"
	CreatedAt   time.Time              `json:"created_at"`
	UpdatedAt   time.Time              `json:"updated_at"`
	Metadata    map[string]interface{} `json:"metadata"`
	Moderation  *ModerationInfo        `json:"moderation,omitempty"`
}

// Comment represents a comment on a post
type Comment struct {
	ID         string                 `json:"id"`
	PostID     string                 `json:"post_id"`
	Author     string                 `json:"author"`
	Content    string                 `json:"content"`
	ParentID   string                 `json:"parent_id,omitempty"` // For nested comments
	Likes      int64                  `json:"likes"`
	Replies    int64                  `json:"replies"`
	Status     string                 `json:"status"` // "active", "hidden", "deleted"
	CreatedAt  time.Time              `json:"created_at"`
	UpdatedAt  time.Time              `json:"updated_at"`
	Metadata   map[string]interface{} `json:"metadata"`
	Moderation *ModerationInfo        `json:"moderation,omitempty"`
}

// Like represents a like on a post or comment
type Like struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	TargetID  string    `json:"target_id"` // Post or comment ID
	TargetType string   `json:"target_type"` // "post" or "comment"
	Type      string    `json:"type"` // "like", "love", "laugh", "wow", "sad", "angry"
	CreatedAt time.Time `json:"created_at"`
}

// Feed represents a user's personalized feed
type Feed struct {
	UserID    string    `json:"user_id"`
	Posts     []*Post   `json:"posts"`
	LastSync  time.Time `json:"last_sync"`
	Algorithm string    `json:"algorithm"` // "chronological", "relevance", "trending"
}

// ContentModerator handles content moderation
type ContentModerator struct {
	filters    map[string]*ContentFilter
	blacklist  map[string]bool
	whitelist  map[string]bool
	aiModel    *AIModerator
	moderators []string
}

// ContentFilter represents a content filtering rule
type ContentFilter struct {
	ID          string   `json:"id"`
	Name        string   `json:"name"`
	Type        string   `json:"type"` // "keyword", "regex", "ai"
	Patterns    []string `json:"patterns"`
	Action      string   `json:"action"` // "flag", "hide", "delete", "warn"
	Severity    string   `json:"severity"` // "low", "medium", "high", "critical"
	IsActive    bool     `json:"is_active"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// AIModerator represents AI-based content moderation
type AIModerator struct {
	ModelVersion string  `json:"model_version"`
	Confidence   float64 `json:"confidence_threshold"`
	Categories   []string `json:"categories"`
}

// ModerationInfo contains moderation details
type ModerationInfo struct {
	Status      string    `json:"status"` // "pending", "approved", "flagged", "hidden"
	Reason      string    `json:"reason,omitempty"`
	Moderator   string    `json:"moderator,omitempty"`
	ReviewedAt  time.Time `json:"reviewed_at,omitempty"`
	AutoFlagged bool      `json:"auto_flagged"`
	Score       float64   `json:"score,omitempty"`
}

// TrendingManager manages trending content
type TrendingManager struct {
	trendingPosts []*TrendingItem
	trendingTags  []*TrendingItem
	algorithm     string
	lastUpdate    time.Time
}

// TrendingItem represents a trending post or hashtag
type TrendingItem struct {
	ID          string    `json:"id"`
	Type        string    `json:"type"` // "post" or "hashtag"
	Score       float64   `json:"score"`
	Trend       string    `json:"trend"` // "rising", "stable", "falling"
	LastUpdated time.Time `json:"last_updated"`
}

// Hashtag represents a hashtag with usage statistics
type Hashtag struct {
	Tag         string    `json:"tag"`
	Count       int64     `json:"count"`
	Posts       []string  `json:"posts"`
	Trending    bool      `json:"trending"`
	CreatedAt   time.Time `json:"created_at"`
	LastUsed    time.Time `json:"last_used"`
}

// Report represents a content report
type Report struct {
	ID          string    `json:"id"`
	Reporter    string    `json:"reporter"`
	TargetID    string    `json:"target_id"`
	TargetType  string    `json:"target_type"` // "post" or "comment"
	Reason      string    `json:"reason"`
	Description string    `json:"description,omitempty"`
	Status      string    `json:"status"` // "pending", "reviewed", "resolved", "dismissed"
	Priority    string    `json:"priority"` // "low", "medium", "high", "urgent"
	CreatedAt   time.Time `json:"created_at"`
	ReviewedAt  *time.Time `json:"reviewed_at,omitempty"`
	ReviewedBy  string    `json:"reviewed_by,omitempty"`
}

// NewSocialManager creates a new social media manager
func NewSocialManager(identityManager *identity.IdentityManager) *SocialManager {
	return &SocialManager{
		posts:           make(map[string]*Post),
		comments:        make(map[string]*Comment),
		likes:           make(map[string]*Like),
		feeds:           make(map[string]*Feed),
		moderation:      NewContentModerator(),
		trending:        NewTrendingManager(),
		hashtags:        make(map[string]*Hashtag),
		mentions:        make(map[string][]string),
		reports:         make(map[string]*Report),
		identityManager: identityManager,
	}
}

// CreatePost creates a new social media post
func (sm *SocialManager) CreatePost(author, content string, mediaURLs []string, visibility, category string) (*Post, error) {
	// Validate content
	if len(strings.TrimSpace(content)) == 0 {
		return nil, fmt.Errorf("post content cannot be empty")
	}

	// Extract hashtags and mentions
	hashtags := extractHashtags(content)
	mentions := extractMentions(content)

	// Moderate content
	moderationInfo := sm.moderation.ModerateContent(content, author)

	postID := generatePostID(author)
	post := &Post{
		ID:         postID,
		Author:     author,
		Content:    content,
		MediaURLs:  mediaURLs,
		Hashtags:   hashtags,
		Mentions:   mentions,
		Visibility: visibility,
		Category:   category,
		Likes:      0,
		Comments:   0,
		Shares:     0,
		Views:      0,
		Status:     "active",
		CreatedAt:  time.Now(),
		UpdatedAt:  time.Now(),
		Metadata:   make(map[string]interface{}),
		Moderation: moderationInfo,
	}

	// Set status based on moderation
	if moderationInfo.Status == "flagged" {
		post.Status = "hidden"
	}

	sm.posts[postID] = post

	// Update hashtags
	for _, tag := range hashtags {
		sm.updateHashtag(tag, postID)
	}

	// Update mentions
	for _, mention := range mentions {
		sm.updateMentions(mention, postID)
	}

	// Update user activity
	if sm.identityManager != nil {
		sm.identityManager.UpdateActivity(author, "post", 1)
	}

	return post, nil
}

// GetPost returns a post by ID
func (sm *SocialManager) GetPost(postID string) (*Post, error) {
	post, exists := sm.posts[postID]
	if !exists {
		return nil, fmt.Errorf("post %s not found", postID)
	}

	// Increment view count
	post.Views++
	post.UpdatedAt = time.Now()

	return post, nil
}

// CreateComment creates a comment on a post
func (sm *SocialManager) CreateComment(postID, author, content, parentID string) (*Comment, error) {
	// Validate post exists
	post, exists := sm.posts[postID]
	if !exists {
		return nil, fmt.Errorf("post %s not found", postID)
	}

	if post.Status != "active" {
		return nil, fmt.Errorf("cannot comment on %s post", post.Status)
	}

	// Validate content
	if len(strings.TrimSpace(content)) == 0 {
		return nil, fmt.Errorf("comment content cannot be empty")
	}

	// Moderate content
	moderationInfo := sm.moderation.ModerateContent(content, author)

	commentID := generateCommentID(author, postID)
	comment := &Comment{
		ID:         commentID,
		PostID:     postID,
		Author:     author,
		Content:    content,
		ParentID:   parentID,
		Likes:      0,
		Replies:    0,
		Status:     "active",
		CreatedAt:  time.Now(),
		UpdatedAt:  time.Now(),
		Metadata:   make(map[string]interface{}),
		Moderation: moderationInfo,
	}

	// Set status based on moderation
	if moderationInfo.Status == "flagged" {
		comment.Status = "hidden"
	}

	sm.comments[commentID] = comment

	// Update post comment count
	post.Comments++
	post.UpdatedAt = time.Now()

	// Update parent comment reply count if nested
	if parentID != "" {
		if parentComment, exists := sm.comments[parentID]; exists {
			parentComment.Replies++
			parentComment.UpdatedAt = time.Now()
		}
	}

	// Update user activity
	if sm.identityManager != nil {
		sm.identityManager.UpdateActivity(author, "comment", 1)
	}

	return comment, nil
}

// LikePost likes a post
func (sm *SocialManager) LikePost(postID, userID, likeType string) error {
	// Validate post exists
	post, exists := sm.posts[postID]
	if !exists {
		return fmt.Errorf("post %s not found", postID)
	}

	if post.Status != "active" {
		return fmt.Errorf("cannot like %s post", post.Status)
	}

	// Check if already liked
	likeID := generateLikeID(userID, postID)
	if _, exists := sm.likes[likeID]; exists {
		return fmt.Errorf("user already liked this post")
	}

	like := &Like{
		ID:         likeID,
		UserID:     userID,
		TargetID:   postID,
		TargetType: "post",
		Type:       likeType,
		CreatedAt:  time.Now(),
	}

	sm.likes[likeID] = like

	// Update post like count
	post.Likes++
	post.UpdatedAt = time.Now()

	// Update user activity
	if sm.identityManager != nil {
		sm.identityManager.UpdateActivity(userID, "like_given", 1)
		sm.identityManager.UpdateActivity(post.Author, "like_received", 1)
	}

	return nil
}

// UnlikePost removes a like from a post
func (sm *SocialManager) UnlikePost(postID, userID string) error {
	likeID := generateLikeID(userID, postID)
	_, exists := sm.likes[likeID]
	if !exists {
		return fmt.Errorf("like not found")
	}

	// Remove like
	delete(sm.likes, likeID)

	// Update post like count
	if post, exists := sm.posts[postID]; exists {
		post.Likes--
		if post.Likes < 0 {
			post.Likes = 0
		}
		post.UpdatedAt = time.Now()
	}

	return nil
}

// GetFeed returns a user's personalized feed
func (sm *SocialManager) GetFeed(userID string, limit int) ([]*Post, error) {
	feed, exists := sm.feeds[userID]
	if !exists {
		// Create new feed
		feed = &Feed{
			UserID:    userID,
			Posts:     make([]*Post, 0),
			LastSync:  time.Now(),
			Algorithm: "relevance",
		}
		sm.feeds[userID] = feed
	}

	// Get posts based on algorithm
	var posts []*Post
	switch feed.Algorithm {
	case "chronological":
		posts = sm.getChronologicalFeed(userID, limit)
	case "relevance":
		posts = sm.getRelevanceFeed(userID, limit)
	case "trending":
		posts = sm.getTrendingFeed(limit)
	default:
		posts = sm.getChronologicalFeed(userID, limit)
	}

	// Update feed
	feed.Posts = posts
	feed.LastSync = time.Now()

	return posts, nil
}

// getChronologicalFeed returns posts in chronological order
func (sm *SocialManager) getChronologicalFeed(userID string, limit int) []*Post {
	var posts []*Post
	for _, post := range sm.posts {
		if post.Status == "active" && (post.Visibility == "public" || post.Author == userID) {
			posts = append(posts, post)
		}
	}

	// Sort by creation time (newest first)
	sort.Slice(posts, func(i, j int) bool {
		return posts[i].CreatedAt.After(posts[j].CreatedAt)
	})

	// Limit results
	if len(posts) > limit {
		posts = posts[:limit]
	}

	return posts
}

// getRelevanceFeed returns posts based on relevance to user
func (sm *SocialManager) getRelevanceFeed(userID string, limit int) []*Post {
	// Get user identity for relevance calculation
	var userIdentity *identity.UserIdentity
	if sm.identityManager != nil {
		userIdentity, _ = sm.identityManager.GetIdentity(userID)
	}

	var posts []*Post
	for _, post := range sm.posts {
		if post.Status == "active" && (post.Visibility == "public" || post.Author == userID) {
			// Calculate relevance score
			relevance := sm.calculateRelevance(post, userIdentity)
			post.Metadata["relevance_score"] = relevance
			posts = append(posts, post)
		}
	}

	// Sort by relevance score
	sort.Slice(posts, func(i, j int) bool {
		scoreI := posts[i].Metadata["relevance_score"].(float64)
		scoreJ := posts[j].Metadata["relevance_score"].(float64)
		return scoreI > scoreJ
	})

	// Limit results
	if len(posts) > limit {
		posts = posts[:limit]
	}

	return posts
}

// getTrendingFeed returns trending posts
func (sm *SocialManager) getTrendingFeed(limit int) []*Post {
	var posts []*Post
	for _, post := range sm.posts {
		if post.Status == "active" {
			// Calculate trending score
			trendingScore := sm.calculateTrendingScore(post)
			post.Metadata["trending_score"] = trendingScore
			posts = append(posts, post)
		}
	}

	// Sort by trending score
	sort.Slice(posts, func(i, j int) bool {
		scoreI := posts[i].Metadata["trending_score"].(float64)
		scoreJ := posts[j].Metadata["trending_score"].(float64)
		return scoreI > scoreJ
	})

	// Limit results
	if len(posts) > limit {
		posts = posts[:limit]
	}

	return posts
}

// calculateRelevance calculates relevance score for a post
func (sm *SocialManager) calculateRelevance(post *Post, userIdentity *identity.UserIdentity) float64 {
	score := 0.0

	// Base score from engagement
	score += float64(post.Likes) * 0.1
	score += float64(post.Comments) * 0.2
	score += float64(post.Shares) * 0.3

	// Recency bonus
	hoursSinceCreation := time.Since(post.CreatedAt).Hours()
	if hoursSinceCreation < 24 {
		score += 10.0
	} else if hoursSinceCreation < 168 { // 1 week
		score += 5.0
	}

	// User-specific factors
	if userIdentity != nil {
		// Category preference
		if post.Category == "governance" && userIdentity.Activity.ProposalsCreated > 0 {
			score += 5.0
		}
		if post.Category == "commerce" && userIdentity.Activity.Transactions > 0 {
			score += 3.0
		}

		// Author reputation
		if sm.identityManager != nil {
			if authorIdentity, err := sm.identityManager.GetIdentity(post.Author); err == nil {
				score += authorIdentity.Reputation.Overall * 0.1
			}
		}
	}

	return score
}

// calculateTrendingScore calculates trending score for a post
func (sm *SocialManager) calculateTrendingScore(post *Post) float64 {
	score := 0.0

	// Engagement velocity
	hoursSinceCreation := time.Since(post.CreatedAt).Hours()
	if hoursSinceCreation > 0 {
		engagementRate := float64(post.Likes+post.Comments*2+post.Shares*3) / hoursSinceCreation
		score += engagementRate * 10.0
	}

	// Absolute engagement
	score += float64(post.Likes) * 0.1
	score += float64(post.Comments) * 0.2
	score += float64(post.Shares) * 0.5
	score += float64(post.Views) * 0.01

	// Recency penalty
	if hoursSinceCreation > 168 { // 1 week
		score *= 0.5
	}

	return score
}

// ReportContent reports content for moderation
func (sm *SocialManager) ReportContent(reporter, targetID, targetType, reason, description string) error {
	// Validate target exists
	if targetType == "post" {
		if _, exists := sm.posts[targetID]; !exists {
			return fmt.Errorf("post %s not found", targetID)
		}
	} else if targetType == "comment" {
		if _, exists := sm.comments[targetID]; !exists {
			return fmt.Errorf("comment %s not found", targetID)
		}
	} else {
		return fmt.Errorf("invalid target type: %s", targetType)
	}

	reportID := generateReportID(reporter, targetID)
	report := &Report{
		ID:          reportID,
		Reporter:    reporter,
		TargetID:    targetID,
		TargetType:  targetType,
		Reason:      reason,
		Description: description,
		Status:      "pending",
		Priority:    "medium",
		CreatedAt:   time.Now(),
	}

	sm.reports[reportID] = report

	return nil
}

// GetTrendingHashtags returns trending hashtags
func (sm *SocialManager) GetTrendingHashtags(limit int) []*Hashtag {
	var hashtags []*Hashtag
	for _, hashtag := range sm.hashtags {
		hashtags = append(hashtags, hashtag)
	}

	// Sort by count
	sort.Slice(hashtags, func(i, j int) bool {
		return hashtags[i].Count > hashtags[j].Count
	})

	// Limit results
	if len(hashtags) > limit {
		hashtags = hashtags[:limit]
	}

	return hashtags
}

// SearchPosts searches posts by content, hashtags, or author
func (sm *SocialManager) SearchPosts(query string, limit int) []*Post {
	query = strings.ToLower(query)
	var results []*Post

	for _, post := range sm.posts {
		if post.Status != "active" {
			continue
		}

		// Search in content
		if strings.Contains(strings.ToLower(post.Content), query) {
			results = append(results, post)
			continue
		}

		// Search in hashtags
		for _, hashtag := range post.Hashtags {
			if strings.Contains(strings.ToLower(hashtag), query) {
				results = append(results, post)
				break
			}
		}

		// Search in author
		if strings.Contains(strings.ToLower(post.Author), query) {
			results = append(results, post)
		}
	}

	// Sort by relevance (simplified)
	sort.Slice(results, func(i, j int) bool {
		return results[i].CreatedAt.After(results[j].CreatedAt)
	})

	// Limit results
	if len(results) > limit {
		results = results[:limit]
	}

	return results
}

// Helper functions
func extractHashtags(content string) []string {
	var hashtags []string
	words := strings.Fields(content)
	for _, word := range words {
		if strings.HasPrefix(word, "#") && len(word) > 1 {
			hashtag := strings.ToLower(strings.TrimPrefix(word, "#"))
			hashtag = strings.Trim(hashtag, ".,!?;:")
			if hashtag != "" {
				hashtags = append(hashtags, hashtag)
			}
		}
	}
	return hashtags
}

func extractMentions(content string) []string {
	var mentions []string
	words := strings.Fields(content)
	for _, word := range words {
		if strings.HasPrefix(word, "@") && len(word) > 1 {
			mention := strings.TrimPrefix(word, "@")
			mention = strings.Trim(mention, ".,!?;:")
			if mention != "" {
				mentions = append(mentions, mention)
			}
		}
	}
	return mentions
}

func (sm *SocialManager) updateHashtag(tag, postID string) {
	hashtag, exists := sm.hashtags[tag]
	if !exists {
		hashtag = &Hashtag{
			Tag:       tag,
			Count:     0,
			Posts:     make([]string, 0),
			Trending:  false,
			CreatedAt: time.Now(),
		}
		sm.hashtags[tag] = hashtag
	}

	hashtag.Count++
	hashtag.Posts = append(hashtag.Posts, postID)
	hashtag.LastUsed = time.Now()

	// Check if trending
	if hashtag.Count >= 10 {
		hashtag.Trending = true
	}
}

func (sm *SocialManager) updateMentions(mention, postID string) {
	sm.mentions[mention] = append(sm.mentions[mention], postID)
}

// Content moderation functions
func NewContentModerator() *ContentModerator {
	return &ContentModerator{
		filters:    make(map[string]*ContentFilter),
		blacklist:  make(map[string]bool),
		whitelist:  make(map[string]bool),
		aiModel:    &AIModerator{ModelVersion: "1.0", Confidence: 0.8},
		moderators: make([]string, 0),
	}
}

func (cm *ContentModerator) ModerateContent(content, author string) *ModerationInfo {
	// Simple keyword-based moderation for now
	// In production, this would use AI/ML models

	contentLower := strings.ToLower(content)
	
	// Check for obvious violations
	if strings.Contains(contentLower, "spam") || strings.Contains(contentLower, "scam") {
		return &ModerationInfo{
			Status:      "flagged",
			Reason:      "Potential spam content",
			AutoFlagged: true,
			Score:       0.8,
		}
	}

	// Check for excessive caps
	upperCount := 0
	for _, char := range content {
		if char >= 'A' && char <= 'Z' {
			upperCount++
		}
	}
	if float64(upperCount)/float64(len(content)) > 0.7 {
		return &ModerationInfo{
			Status:      "flagged",
			Reason:      "Excessive capitalization",
			AutoFlagged: true,
			Score:       0.6,
		}
	}

	// Default: approved
	return &ModerationInfo{
		Status:      "approved",
		AutoFlagged: false,
		Score:       0.1,
	}
}

// Trending manager functions
func NewTrendingManager() *TrendingManager {
	return &TrendingManager{
		trendingPosts: make([]*TrendingItem, 0),
		trendingTags:  make([]*TrendingItem, 0),
		algorithm:     "engagement_velocity",
		lastUpdate:    time.Now(),
	}
}

// Helper ID generation functions
func generatePostID(author string) string {
	data := fmt.Sprintf("post_%s_%d", author, time.Now().Unix())
	hash := sha256.Sum256([]byte(data))
	return hex.EncodeToString(hash[:16])
}

func generateCommentID(author, postID string) string {
	data := fmt.Sprintf("comment_%s_%s_%d", author, postID, time.Now().Unix())
	hash := sha256.Sum256([]byte(data))
	return hex.EncodeToString(hash[:16])
}

func generateLikeID(userID, targetID string) string {
	data := fmt.Sprintf("like_%s_%s", userID, targetID)
	hash := sha256.Sum256([]byte(data))
	return hex.EncodeToString(hash[:16])
}

func generateReportID(reporter, targetID string) string {
	data := fmt.Sprintf("report_%s_%s_%d", reporter, targetID, time.Now().Unix())
	hash := sha256.Sum256([]byte(data))
	return hex.EncodeToString(hash[:16])
} 