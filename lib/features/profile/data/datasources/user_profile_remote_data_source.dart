// lib/features/profile/data/datasources/user_profile_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile_entity.dart';

/// Remote data source for user profile operations using Firestore
///
/// Handles all Firestore operations for user profiles
abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> createProfile(UserProfileModel profile);
  Future<UserProfileModel> getProfile(String userId);
  Future<UserProfileModel> updateProfile(UserProfileModel profile);
  Future<bool> profileExists(String userId);
  Stream<UserProfileModel> watchProfile(String userId);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  UserProfileRemoteDataSourceImpl({
    required this.firestore,
  });

  /// Collection reference for user profiles
  CollectionReference get _profilesCollection =>
      firestore.collection('userProfiles');

  @override
  Future<UserProfileModel> createProfile(UserProfileModel profile) async {
    try {
      await _profilesCollection.doc(profile.userId).set(profile.toFirestore());
      return profile;
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      final doc = await _profilesCollection.doc(userId).get();

      if (!doc.exists) {
        throw Exception('Profile not found for user: $userId');
      }

      return UserProfileModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    try {
      await _profilesCollection.doc(profile.userId).update(profile.toFirestore());
      return profile;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<bool> profileExists(String userId) async {
    try {
      final doc = await _profilesCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check profile existence: $e');
    }
  }

  @override
  Stream<UserProfileModel> watchProfile(String userId) {
    try {
      return _profilesCollection.doc(userId).snapshots().map((doc) {
        if (!doc.exists) {
          throw Exception('Profile not found for user: $userId');
        }
        return UserProfileModel.fromFirestore(doc);
      });
    } catch (e) {
      throw Exception('Failed to watch profile: $e');
    }
  }

  /// Updates match statistics
  Future<UserProfileModel> updateMatchStats({
    required String userId,
    required MatchResult result,
  }) async {
    try {
      final docRef = _profilesCollection.doc(userId);

      return await firestore.runTransaction<UserProfileModel>((transaction) async {
        final doc = await transaction.get(docRef);

        if (!doc.exists) {
          throw Exception('Profile not found for user: $userId');
        }

        final currentProfile = UserProfileModel.fromFirestore(doc);

        // Calculate new stats
        final newMatchesPlayed = currentProfile.matchesPlayed + 1;
        final newWins = result.outcome == MatchOutcome.win
            ? currentProfile.wins + 1
            : currentProfile.wins;
        final newLosses = result.outcome == MatchOutcome.loss
            ? currentProfile.losses + 1
            : currentProfile.losses;
        final newDraws = result.outcome == MatchOutcome.draw
            ? currentProfile.draws + 1
            : currentProfile.draws;
        final newGmrPoints = currentProfile.gmrPoints + result.gmrPointsChange;
        final newMedalLevel = MedalLevel.fromGmrPoints(newGmrPoints);

        // Add sport if not already in list
        final newSports = currentProfile.sports.contains(result.sport)
            ? currentProfile.sports
            : [...currentProfile.sports, result.sport];

        final updatedModel = UserProfileModel(
          userId: currentProfile.userId,
          displayName: currentProfile.displayName,
          email: currentProfile.email,
          photoUrl: currentProfile.photoUrl,
          phoneNumber: currentProfile.phoneNumber,
          gmrPoints: newGmrPoints,
          medalLevel: newMedalLevel.name,
          matchesPlayed: newMatchesPlayed,
          wins: newWins,
          losses: newLosses,
          draws: newDraws,
          sports: newSports,
          achievements: currentProfile.achievements,
          createdAt: currentProfile.createdAt,
          updatedAt: DateTime.now(),
        );

        transaction.update(docRef, updatedModel.toFirestore());
        return updatedModel;
      });
    } catch (e) {
      throw Exception('Failed to update match stats: $e');
    }
  }

  /// Adds an achievement
  Future<UserProfileModel> addAchievement({
    required String userId,
    required Achievement achievement,
  }) async {
    try {
      final profile = await getProfile(userId);

      // Check if achievement already exists
      final existingAchievements = profile.achievements;
      if (existingAchievements.any((a) => a.id == achievement.id)) {
        return profile; // Already has this achievement
      }

      final updatedAchievements = [
        ...existingAchievements,
        AchievementModel.fromEntity(achievement),
      ];

      final updatedModel = UserProfileModel(
        userId: profile.userId,
        displayName: profile.displayName,
        email: profile.email,
        photoUrl: profile.photoUrl,
        phoneNumber: profile.phoneNumber,
        gmrPoints: profile.gmrPoints,
        medalLevel: profile.medalLevel,
        matchesPlayed: profile.matchesPlayed,
        wins: profile.wins,
        losses: profile.losses,
        draws: profile.draws,
        sports: profile.sports,
        achievements: updatedAchievements,
        createdAt: profile.createdAt,
        updatedAt: DateTime.now(),
      );

      await _profilesCollection.doc(userId).update(updatedModel.toFirestore());
      return updatedModel;
    } catch (e) {
      throw Exception('Failed to add achievement: $e');
    }
  }

  /// Updates user's sports
  Future<UserProfileModel> updateSports({
    required String userId,
    required List<String> sports,
  }) async {
    try {
      final profile = await getProfile(userId);

      final updatedModel = UserProfileModel(
        userId: profile.userId,
        displayName: profile.displayName,
        email: profile.email,
        photoUrl: profile.photoUrl,
        phoneNumber: profile.phoneNumber,
        gmrPoints: profile.gmrPoints,
        medalLevel: profile.medalLevel,
        matchesPlayed: profile.matchesPlayed,
        wins: profile.wins,
        losses: profile.losses,
        draws: profile.draws,
        sports: sports,
        achievements: profile.achievements,
        createdAt: profile.createdAt,
        updatedAt: DateTime.now(),
      );

      await _profilesCollection.doc(userId).update(updatedModel.toFirestore());
      return updatedModel;
    } catch (e) {
      throw Exception('Failed to update sports: $e');
    }
  }
}