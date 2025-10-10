// lib/features/profile/domain/entities/user_profile_entity.dart

import 'package:equatable/equatable.dart';

/// Core business entity representing a user's profile
///
/// This is a pure Dart class with no external dependencies.
/// Contains all user statistics and profile information.
class UserProfileEntity extends Equatable {
  final String userId;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;

  // Game Statistics
  final int gmrPoints;
  final MedalLevel medalLevel;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int draws;

  // Sports user plays
  final List<String> sports;

  // Achievements
  final List<Achievement> achievements;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
    required this.userId,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
    required this.gmrPoints,
    required this.medalLevel,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.sports,
    required this.achievements,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new user profile with initial default values
  factory UserProfileEntity.initial({
    required String userId,
    required String displayName,
    required String email,
    String? photoUrl,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    return UserProfileEntity(
      userId: userId,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      gmrPoints: 1000, // Starting GMR points
      medalLevel: MedalLevel.bronze,
      matchesPlayed: 0,
      wins: 0,
      losses: 0,
      draws: 0,
      sports: [], // User will select sports during onboarding
      achievements: [
        Achievement(
          id: 'welcome',
          title: 'Welcome to REDvsBLUE',
          description: 'Created your account',
          icon: 'star',
          earnedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Calculates win rate as a percentage
  double get winRate {
    if (matchesPlayed == 0) return 0.0;
    return (wins / matchesPlayed) * 100;
  }

  /// Total games that resulted in a win or loss (excluding draws)
  int get totalDecidedMatches => wins + losses;

  /// Checks if user has played any matches
  bool get hasPlayedMatches => matchesPlayed > 0;

  /// Creates a copy with updated fields
  UserProfileEntity copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    int? gmrPoints,
    MedalLevel? medalLevel,
    int? matchesPlayed,
    int? wins,
    int? losses,
    int? draws,
    List<String>? sports,
    List<Achievement>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gmrPoints: gmrPoints ?? this.gmrPoints,
      medalLevel: medalLevel ?? this.medalLevel,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      sports: sports ?? this.sports,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    email,
    photoUrl,
    phoneNumber,
    gmrPoints,
    medalLevel,
    matchesPlayed,
    wins,
    losses,
    draws,
    sports,
    achievements,
    createdAt,
    updatedAt,
  ];
}

/// Medal/Level system based on GMR points
enum MedalLevel {
  bronze(minPoints: 0, maxPoints: 1499, displayName: 'Bronze'),
  silver(minPoints: 1500, maxPoints: 1999, displayName: 'Silver'),
  gold(minPoints: 2000, maxPoints: 2499, displayName: 'Gold'),
  platinum(minPoints: 2500, maxPoints: 2999, displayName: 'Platinum'),
  diamond(minPoints: 3000, maxPoints: 9999, displayName: 'Diamond');

  const MedalLevel({
    required this.minPoints,
    required this.maxPoints,
    required this.displayName,
  });

  final int minPoints;
  final int maxPoints;
  final String displayName;

  /// Gets medal level based on GMR points
  static MedalLevel fromGmrPoints(int points) {
    if (points >= diamond.minPoints) return diamond;
    if (points >= platinum.minPoints) return platinum;
    if (points >= gold.minPoints) return gold;
    if (points >= silver.minPoints) return silver;
    return bronze;
  }

  /// Points needed to reach next level
  int pointsToNextLevel(int currentPoints) {
    if (this == diamond) return 0; // Already at max
    final nextLevel = MedalLevel.values[index + 1];
    return nextLevel.minPoints - currentPoints;
  }
}

/// Achievement entity
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon; // Icon name or path
  final DateTime earnedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.earnedAt,
  });

  @override
  List<Object?> get props => [id, title, description, icon, earnedAt];
}

/// Match result to update user stats
class MatchResult {
  final String matchId;
  final MatchOutcome outcome;
  final int gmrPointsChange;
  final String sport;

  const MatchResult({
    required this.matchId,
    required this.outcome,
    required this.gmrPointsChange,
    required this.sport,
  });
}

enum MatchOutcome {
  win,
  loss,
  draw,
}