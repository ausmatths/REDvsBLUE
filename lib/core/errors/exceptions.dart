/// Base exception class for data layer errors
/// These are converted to Failures in the repository layer
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception when server/API returns an error
class ServerException extends AppException {
  ServerException({required String message}) : super(message);
}

/// Exception when there's no internet connection
class NetworkException extends AppException {
  NetworkException({required String message}) : super(message);
}

/// Exception when validation fails (e.g., invalid input)
class ValidationException extends AppException {
  ValidationException({required String message}) : super(message);
}

/// Exception when requested resource is not found
class NotFoundExceptionCustom extends AppException {
  NotFoundExceptionCustom({required String message}) : super(message);
}

/// Exception when user is not authenticated
class AuthenticationException extends AppException {
  AuthenticationException({required String message}) : super(message);
}

/// Exception when user doesn't have permission
class PermissionException extends AppException {
  PermissionException({required String message}) : super(message);
}

/// Exception when caching data fails
class CacheException extends AppException {
  CacheException({required String message}) : super(message);
}