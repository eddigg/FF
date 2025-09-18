import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_exceptions.dart';
import '../network/api_cache.dart';

/// Base API client class that provides common functionality for all feature API clients
abstract class BaseApiClient {
  final ApiClient apiClient;

  BaseApiClient(this.apiClient);

  /// Executes a GET request with standardized error handling and caching
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? cacheParams,
    bool useCache = true,
    int cacheExpiry = 60000, // 1 minute default
    Options? options,
  }) async {
    try {
      // Try to get cached data first
      if (useCache) {
        final cacheKey = ApiCache.getCacheKey(endpoint, params: cacheParams ?? queryParameters);
        final cachedData = await ApiCache.getCachedData(cacheKey);
        if (cachedData != null) {
          return cachedData as T;
        }
      }

      final response = await apiClient.dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options ?? defaultOptions(),
      );

      if (response.statusCode == 200) {
        // Cache the result
        if (useCache) {
          final cacheKey = ApiCache.getCacheKey(endpoint, params: cacheParams ?? queryParameters);
          await ApiCache.cacheData(cacheKey, response.data as Map<String, dynamic>, expiry: cacheExpiry);
        }
        
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Request failed: $e',
        details: e,
      );
    }
  }

  /// Executes a POST request with standardized error handling
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await apiClient.dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ?? defaultOptions(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Request failed: $e',
        details: e,
      );
    }
  }

  /// Executes a PUT request with standardized error handling
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await apiClient.dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options ?? defaultOptions(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Request failed: $e',
        details: e,
      );
    }
  }

  /// Executes a DELETE request with standardized error handling
  Future<T> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await apiClient.dio.delete<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options ?? defaultOptions(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Request failed: $e',
        details: e,
      );
    }
  }

  /// Default options for API requests
  Options defaultOptions() {
    return Options(
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    );
  }

  /// Handle DioException and convert to appropriate ApiException
  ApiException _handleDioException(DioException e) {
    if (e.error is ApiException) {
      return e.error as ApiException;
    }
    
    if (e.response?.statusCode != null) {
      final statusCode = e.response!.statusCode!;
      switch (statusCode) {
        case 400:
          return ClientException(
            message: 'Bad request: ${e.response?.data['message'] ?? e.message}',
            statusCode: statusCode,
            details: e.response?.data,
          );
        case 401:
          return AuthException(
            message: 'Unauthorized: Please log in again',
            statusCode: statusCode,
          );
        case 403:
          return AuthException(
            message: 'Forbidden: You do not have permission to access this resource',
            statusCode: statusCode,
          );
        case 404:
          return NotFoundException(
            message: 'Resource not found',
            statusCode: statusCode,
          );
        case 408:
          return TimeoutException(
            message: 'Request timeout',
            statusCode: statusCode,
          );
        case 429:
          return ClientException(
            message: 'Too many requests. Please try again later',
            statusCode: statusCode,
          );
        case 500:
        case 502:
        case 503:
          return ServerException(
            message: 'Server error. Please try again later',
            statusCode: statusCode,
          );
        default:
          if (statusCode >= 500 && statusCode < 600) {
            return ServerException(
              message: 'Server error (status: $statusCode)',
              statusCode: statusCode,
            );
          } else if (statusCode >= 400 && statusCode < 500) {
            return ClientException(
              message: 'Client error (status: $statusCode)',
              statusCode: statusCode,
            );
          }
      }
    }
    
    // Handle network errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Connection timeout. Please check your network connection',
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection error. Please check your network connection',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Bad response from server',
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
        );
      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'SSL certificate error',
        );
      default:
        return NetworkException(
          message: 'Network error. Please check your connection',
        );
    }
  }

  /// Clear cache for a specific endpoint
  Future<void> clearCache(String endpoint, [Map<String, dynamic>? params]) async {
    try {
      final cacheKey = ApiCache.getCacheKey(endpoint, params: params);
      await ApiCache.clearCache(cacheKey);
    } catch (e) {
      // Silently ignore cache clearing errors
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      await ApiCache.clearAllCache();
    } catch (e) {
      // Silently ignore cache clearing errors
    }
  }
}