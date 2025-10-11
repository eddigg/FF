/// Custom exception class for API-related errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic details;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('ApiException: $message');
    
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    
    if (errorCode != null) {
      buffer.write(' (Code: $errorCode)');
    }
    
    return buffer.toString();
  }
}

/// Exception for network connectivity issues
class NetworkException extends ApiException {
  NetworkException({
    String message = 'Network connection error',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}

/// Exception for authentication/authorization issues
class AuthException extends ApiException {
  AuthException({
    String message = 'Authentication failed',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}

/// Exception for resource not found (404)
class NotFoundException extends ApiException {
  NotFoundException({
    String message = 'Resource not found',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}

/// Exception for server-side errors (5xx)
class ServerException extends ApiException {
  ServerException({
    String message = 'Server error occurred',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}

/// Exception for client-side errors (4xx, excluding 404)
class ClientException extends ApiException {
  ClientException({
    String message = 'Client error occurred',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}

/// Exception for timeout errors
class TimeoutException extends ApiException {
  TimeoutException({
    String message = 'Request timeout',
    int? statusCode,
    String? errorCode,
    dynamic details,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          details: details,
        );
}
