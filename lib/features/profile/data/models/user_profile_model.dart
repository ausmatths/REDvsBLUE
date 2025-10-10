// lib/features/profile/data/models/user_profile_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';

/// Data model for UserProfileEntity
///
/// Handles JSON serialization/deserialization for Firestore
class UserProfileModel {
  final String userId;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final int gmrPoints;
  final String medalLevel;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final List<String> sports;
  final List<AchievementModel> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileModel({
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

  /// Converts entity to model
  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      userId: entity.userId,
      displayName: entity.displayName,
      email: entity.email,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      gmrPoints: entity.gmrPoints,
      medalLevel: entity.medalLevel.name,
      matchesPlayed: entity.matchesPlayed,
      wins: entity.wins,
      losses: entity.losses,
      draws: entity.draws,
      sports: entity.sports,
      achievements: entity.achievements
          .map((a) => AchievementModel.fromEntity(a))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts model to entity
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      userId: userId,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      gmrPoints: gmrPoints,
      medalLevel: _parseMedalLevel(medalLevel),
      matchesPlayed: matchesPlayed,
      wins: wins,
      losses: losses,
      draws: draws,
      sports: sports,
      achievements: achievements.map((a) => a.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates model from Firestore document
  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      userId: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      gmrPoints: data['gmrPoints'] ?? 1000,
      medalLevel: data['medalLevel'] ?? 'bronze',
      matchesPlayed: data['matchesPlayed'] ?? 0,
      wins: data['wins'] ?? 0,
      losses: data['losses'] ?? 0,
      draws: data['draws'] ?? 0,
      sports: List<String>.from(data['sports'] ?? []),
      achievements: (data['achievements'] as List<dynamic>?)
          ?.map((a) => AchievementModel.fromJson(a as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'gmrPoints': gmrPoints,
      'medalLevel': medalLevel,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'sports': sports,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Parses medal level from string
  MedalLevel _parseMedalLevel(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return MedalLevel.bronze;
      case 'silver':
        return MedalLevel.silver;
      case 'gold':
        return MedalLevel.gold;
      case 'platinum':
        return MedalLevel.platinum;
      case 'diamond':
        return MedalLevel.diamond;
      default:
        return MedalLevel.bronze;
    }
  }
}

/// Achievement model for JSON serialization
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime earnedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.earnedAt,
  });

  factory AchievementModel.fromEntity(Achievement entity) {
    return AchievementModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      earnedAt: entity.earnedAt,
    );
  }

  Achievement toEntity() {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      earnedAt: earnedAt,
    );
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'star',
      earnedAt: (json['earnedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'earnedAt': Timestamp.fromDate(earnedAt),
    };
  }
}