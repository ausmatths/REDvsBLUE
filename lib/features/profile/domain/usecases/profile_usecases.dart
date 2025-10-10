// lib/features/profile/domain/usecases/profile_usecases.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

/// Use case for creating initial user profile
///
/// This is called when a new user signs up
class CreateInitialProfile {
  final UserProfileRepository repository;

  CreateInitialProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String userId,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    // Create initial profile with default values
    final profile = UserProfileEntity.initial(
      userId: userId,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
    );

    return await repository.createProfile(profile);
  }
}

/// Use case for getting user profile
class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}

/// Use case for updating user profile
class UpdateUserProfile {
  final UserProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(
      UserProfileEntity profile,
      ) async {
    final updatedProfile = profile.copyWith(
      updatedAt: DateTime.now(),
    );
    return await repository.updateProfile(updatedProfile);
  }
}

/// Use case for updating user stats after a match
///
/// This calculates new GMR points, medal level, and statistics
class UpdateMatchStats {
  final UserProfileRepository repository;

  UpdateMatchStats(this.repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String userId,
    required MatchResult result,
  }) async {
    return await repository.updateMatchStats(
      userId: userId,
      result: result,
    );
  }
}

/// Use case for adding an achievement
class AddAchievement {
  final UserProfileRepository repository;

  AddAchievement(this.repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String userId,
    required Achievement achievement,
  }) async {
    return await repository.addAchievement(
      userId: userId,
      achievement: achievement,
    );
  }
}

/// Use case for updating user's sports
class UpdateUserSports {
  final UserProfileRepository repository;

  UpdateUserSports(this.repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String userId,
    required List<String> sports,
  }) async {
    return await repository.updateSports(
      userId: userId,
      sports: sports,
    );
  }
}

/// Use case for checking if profile exists
class CheckProfileExists {
  final UserProfileRepository repository;

  CheckProfileExists(this.repository);

  Future<Either<Failure, bool>> call(String userId) async {
    return await repository.profileExists(userId);
  }
}

/// Use case for watching profile changes in real-time
class WatchUserProfile {
  final UserProfileRepository repository;

  WatchUserProfile(this.repository);

  Stream<Either<Failure, UserProfileEntity>> call(String userId) {
    return repository.watchProfile(userId);
  }
}