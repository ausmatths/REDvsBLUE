// lib/features/profile/presentation/providers/user_profile_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/user_profile_remote_data_source.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'user_profile_providers.g.dart';

// ============================================================================
// Infrastructure Providers
// ============================================================================

/// Provides Firestore instance
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

/// Provides UserProfile remote data source
@riverpod
UserProfileRemoteDataSource userProfileRemoteDataSource(
    UserProfileRemoteDataSourceRef ref,
    ) {
  return UserProfileRemoteDataSourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// Provides UserProfile repository
@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) {
  return UserProfileRepositoryImpl(
    remoteDataSource: ref.watch(userProfileRemoteDataSourceProvider),
  );
}

// ============================================================================
// Use Case Providers
// ============================================================================

@riverpod
CreateInitialProfile createInitialProfile(CreateInitialProfileRef ref) {
  return CreateInitialProfile(ref.watch(userProfileRepositoryProvider));
}

@riverpod
GetUserProfile getUserProfile(GetUserProfileRef ref) {
  return GetUserProfile(ref.watch(userProfileRepositoryProvider));
}

@riverpod
UpdateUserProfile updateUserProfile(UpdateUserProfileRef ref) {
  return UpdateUserProfile(ref.watch(userProfileRepositoryProvider));
}

@riverpod
UpdateMatchStats updateMatchStats(UpdateMatchStatsRef ref) {
  return UpdateMatchStats(ref.watch(userProfileRepositoryProvider));
}

@riverpod
AddAchievement addAchievement(AddAchievementRef ref) {
  return AddAchievement(ref.watch(userProfileRepositoryProvider));
}

@riverpod
UpdateUserSports updateUserSports(UpdateUserSportsRef ref) {
  return UpdateUserSports(ref.watch(userProfileRepositoryProvider));
}

@riverpod
CheckProfileExists checkProfileExists(CheckProfileExistsRef ref) {
  return CheckProfileExists(ref.watch(userProfileRepositoryProvider));
}

// ============================================================================
// State Providers
// ============================================================================

/// Provides user profile for a specific user ID
///
/// This will fetch the profile from Firestore when first accessed
@riverpod
Future<UserProfileEntity> userProfile(
    UserProfileRef ref,
    String userId,
    ) async {
  final getUserProfileUseCase = ref.watch(getUserProfileProvider);
  final result = await getUserProfileUseCase(userId);

  return result.fold(
        (failure) => throw Exception(
      failure is Failure ? failure.message : 'Failed to load user profile',
    ),
        (profile) => profile,
  );
}

/// Provides a stream of user profile that updates in real-time
///
/// Use this for watching profile changes
@riverpod
Stream<UserProfileEntity> userProfileStream(
    UserProfileStreamRef ref,
    String userId,
    ) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchProfile(userId).map(
        (either) => either.fold(
          (failure) => throw Exception(
        failure is Failure ? failure.message : 'Failed to watch user profile',
      ),
          (profile) => profile,
    ),
  );
}

/// State notifier for managing user profile operations
@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  FutureOr<UserProfileEntity?> build() async {
    // Initial state is null until profile is loaded
    return null;
  }

  /// Creates initial profile for a new user
  Future<void> createInitialProfile({
    required String userId,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();

    final createUseCase = ref.read(createInitialProfileProvider);
    final result = await createUseCase(
      userId: userId,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
    );

    state = result.fold(
          (failure) => AsyncValue.error(
        failure is Failure ? failure.message : 'Failed to create profile',
        StackTrace.current,
      ),
          (profile) => AsyncValue.data(profile),
    );
  }

  /// Loads user profile
  Future<void> loadProfile(String userId) async {
    state = const AsyncValue.loading();

    final getUseCase = ref.read(getUserProfileProvider);
    final result = await getUseCase(userId);

    state = result.fold(
          (failure) => AsyncValue.error(
        failure is Failure ? failure.message : 'Failed to load profile',
        StackTrace.current,
      ),
          (profile) => AsyncValue.data(profile),
    );
  }

  /// Updates user profile
  Future<void> updateProfile(UserProfileEntity profile) async {
    state = const AsyncValue.loading();

    final updateUseCase = ref.read(updateUserProfileProvider);
    final result = await updateUseCase(profile);

    state = result.fold(
          (failure) => AsyncValue.error(
        failure is Failure ? failure.message : 'Failed to update profile',
        StackTrace.current,
      ),
          (profile) => AsyncValue.data(profile),
    );
  }

  /// Updates match statistics after a match
  Future<void> updateMatchStats({
    required String userId,
    required MatchResult result,
  }) async {
    // Don't set loading state to avoid UI flicker
    final currentState = state;

    final updateUseCase = ref.read(updateMatchStatsProvider);
    final updateResult = await updateUseCase(
      userId: userId,
      result: result,
    );

    state = updateResult.fold(
          (failure) {
        // Revert to previous state on error
        return currentState;
      },
          (profile) => AsyncValue.data(profile),
    );
  }

  /// Adds an achievement
  Future<void> addAchievement({
    required String userId,
    required Achievement achievement,
  }) async {
    final addUseCase = ref.read(addAchievementProvider);
    final result = await addUseCase(
      userId: userId,
      achievement: achievement,
    );

    state = result.fold(
          (failure) => state, // Keep current state on error
          (profile) => AsyncValue.data(profile),
    );
  }

  /// Updates user's sports
  Future<void> updateSports({
    required String userId,
    required List<String> sports,
  }) async {
    state = const AsyncValue.loading();

    final updateUseCase = ref.read(updateUserSportsProvider);
    final result = await updateUseCase(
      userId: userId,
      sports: sports,
    );

    state = result.fold(
          (failure) => AsyncValue.error(
        failure is Failure ? failure.message : 'Failed to update sports',
        StackTrace.current,
      ),
          (profile) => AsyncValue.data(profile),
    );
  }
}