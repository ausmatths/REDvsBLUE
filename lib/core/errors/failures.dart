// lib/core/errors/failures.dart

import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
///
/// Failures represent errors in the domain layer and are returned
/// via Either<Failure, T> from repositories and use cases
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Failure when server returns an error
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Failure when validation fails (e.g., invalid input)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Failure when requested resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

/// Failure when user is not authenticated
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

/// Failure when user doesn't have permission
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Failure when caching data fails
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure for unexpected/unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}