import 'package:dio/dio.dart';
import '../utils/logger.dart';
import 'api_exceptions.dart';

class ApiClient {
  static Dio? _dioInstance;
  static late String _baseUrl;

  static Dio initialize({required String baseUrl}) {
    _baseUrl = baseUrl;
    _dioInstance = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dioInstance!.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => AppLogger.log(object.toString()),
      ),
      ErrorInterceptor(),
      AuthInterceptor(),
      RetryInterceptor(),
    ]);
    return _dioInstance!;
  }

  static Dio get instance {
    if (_dioInstance == null) {
      throw StateError(
          'ApiClient has not been initialized. Call initialize() first.');
    }
    return _dioInstance!;
  }

  static String get baseUrl => _baseUrl;

  Dio get dio => instance;

  void updateBaseUrl(String newBaseUrl) {
    if (_dioInstance != null) {
      _dioInstance!.options.baseUrl = newBaseUrl;
      _baseUrl = newBaseUrl;
      AppLogger.log('API Base URL updated to: $_baseUrl');
    } else {
      AppLogger.logError('ApiClient not initialized, cannot update base URL.');
    }
  }

  // Method to add authorization token
  void addAuthorizationToken(String token) {
    if (_dioInstance != null) {
      _dioInstance!.options.headers['Authorization'] = 'Bearer $token';
      AppLogger.log('Authorization token added to requests');
    } else {
      AppLogger.logError('ApiClient not initialized, cannot add authorization token.');
    }
  }

  // Method to remove authorization token
  void removeAuthorizationToken() {
    if (_dioInstance != null) {
      _dioInstance!.options.headers.remove('Authorization');
      AppLogger.log('Authorization token removed from requests');
    } else {
      AppLogger.logError('ApiClient not initialized, cannot remove authorization token.');
    }
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logError('API Error: ${err.message}', err);

    // Create appropriate exception based on error type
    ApiException apiException;

    if (err.response != null) {
      final statusCode = err.response!.statusCode ?? 500;
      final errorMessage = err.response?.data['message'] ?? 'An error occurred';
      final errorCode = err.response?.data['code'];

      switch (statusCode) {
        case 400:
          apiException = ClientException(
            message: 'Bad Request - Please check your input',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 401:
          apiException = AuthException(
            message: 'Unauthorized - Please log in again',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 403:
          apiException = AuthException(
            message: 'Forbidden - You do not have permission to access this resource',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 404:
          apiException = NotFoundException(
            message: 'Resource not found',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 408:
          apiException = TimeoutException(
            message: 'Request timeout - Please try again',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 429:
          apiException = ClientException(
            message: 'Too many requests - Please wait before trying again',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 500:
          apiException = ServerException(
            message: 'Internal server error - Please try again later',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 502:
          apiException = ServerException(
            message: 'Bad gateway - Please try again later',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        case 503:
          apiException = ServerException(
            message: 'Service unavailable - Please try again later',
            statusCode: statusCode,
            errorCode: errorCode,
            details: err.response?.data,
          );
          break;
        default:
          if (statusCode >= 500 && statusCode < 600) {
            apiException = ServerException(
              message: errorMessage,
              statusCode: statusCode,
              errorCode: errorCode,
              details: err.response?.data,
            );
          } else if (statusCode >= 400 && statusCode < 500) {
            apiException = ClientException(
              message: errorMessage,
              statusCode: statusCode,
              errorCode: errorCode,
              details: err.response?.data,
            );
          } else {
            apiException = ApiException(
              message: errorMessage,
              statusCode: statusCode,
              errorCode: errorCode,
              details: err.response?.data,
            );
          }
      }
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          apiException = TimeoutException(
            message: 'Connection timeout - Please check your network connection',
            details: err.error,
          );
          break;
        case DioExceptionType.connectionError:
          apiException = NetworkException(
            message: 'Connection error - Please check your network connection',
            details: err.error,
          );
          break;
        case DioExceptionType.badResponse:
          apiException = ApiException(
            message: 'Bad response from server',
            details: err.error,
          );
          break;
        case DioExceptionType.cancel:
          apiException = ApiException(
            message: 'Request was cancelled',
            details: err.error,
          );
          break;
        case DioExceptionType.badCertificate:
          apiException = ApiException(
            message: 'SSL certificate error',
            details: err.error,
          );
          break;
        default:
          apiException = NetworkException(
            message: 'Network error - Please check your connection',
            details: err.error,
          );
      }
    }

    handler.next(DioException(
      error: apiException,
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
    ));
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the request
    AppLogger.log('Making request to: ${options.uri}');
    AppLogger.log('Request headers: ${options.headers}');
    AppLogger.log('Request data: ${options.data}');
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the response
    AppLogger.log('Received response with status: ${response.statusCode}');
    AppLogger.log('Response data: ${response.data}');
    
    handler.next(response);
  }
}

class RetryInterceptor extends Interceptor {
  final int maxRetries = 3;
  final Duration retryDelay = const Duration(seconds: 1);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Don't retry if the error is due to bad request or authentication
    if (err.response?.statusCode == 400 || 
        err.response?.statusCode == 401 || 
        err.response?.statusCode == 403) {
      return handler.next(err);
    }

    // Check if we should retry
    if (shouldRetry(err)) {
      for (int i = 1; i <= maxRetries; i++) {
        AppLogger.logWarning('Retrying request ($i/$maxRetries)...');
        
        await Future.delayed(retryDelay * i); // Exponential backoff
        
        try {
          // Get the Dio instance from the singleton
          final dio = ApiClient.instance;
          final response = await dio.request<dynamic>(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            cancelToken: err.requestOptions.cancelToken,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              contentType: err.requestOptions.contentType,
              responseType: err.requestOptions.responseType,
              receiveTimeout: err.requestOptions.receiveTimeout,
              sendTimeout: err.requestOptions.sendTimeout,
            ),
            onSendProgress: err.requestOptions.onSendProgress,
            onReceiveProgress: err.requestOptions.onReceiveProgress,
          );
          
          return handler.resolve(response);
        } catch (e) {
          if (i == maxRetries) {
            // Last retry failed, pass the error
            return handler.next(err);
          }
          // Continue to next retry
        }
      }
    }
    
    // Not a retryable error or all retries failed
    handler.next(err);
  }

  bool shouldRetry(DioException err) {
    // Retry on network errors or server errors (5xx)
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on server errors (5xx)
    if (err.response?.statusCode != null &&
        err.response!.statusCode! >= 500 &&
        err.response!.statusCode! < 600) {
      return true;
    }

    return false;
  }
}
