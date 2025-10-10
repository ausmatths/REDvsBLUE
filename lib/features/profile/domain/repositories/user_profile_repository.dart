// lib/features/profile/domain/repositories/user_profile_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';

/// Repository interface for user profile operations
///
/// This is an abstract interface that defines the contract for user profile data operations.
/// The actual implementation will be in the data layer.
abstract class UserProfileRepository {
  /// Creates a new user profile in the database
  ///
  /// Returns [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> createProfile(
      UserProfileEntity profile,
      );

  /// Gets user profile by user ID
  ///
  /// Returns [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> getProfile(String userId);

  /// Updates user profile
  ///
  /// Returns updated [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> updateProfile(
      UserProfileEntity profile,
      );

  /// Updates user stats after a match
  ///
  /// Returns updated [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> updateMatchStats({
    required String userId,
    required MatchResult result,
  });

  /// Adds a new achievement to user profile
  ///
  /// Returns updated [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> addAchievement({
    required String userId,
    required Achievement achievement,
  });

  /// Updates user's sports list
  ///
  /// Returns updated [UserProfileEntity] on success or [Failure] on error
  Future<Either<Failure, UserProfileEntity>> updateSports({
    required String userId,
    required List<String> sports,
  });

  /// Checks if a user profile exists
  ///
  /// Returns true if profile exists, false otherwise
  Future<Either<Failure, bool>> profileExists(String userId);

  /// Streams user profile changes in real-time
  ///
  /// Returns a stream of [UserProfileEntity] or [Failure]
  Stream<Either<Failure, UserProfileEntity>> watchProfile(String userId);
}