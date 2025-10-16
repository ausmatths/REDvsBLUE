import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/friend_entity.dart';

/// Data model for Friend - handles Firebase serialization
class FriendModel {
  final String id;
  final String userId;
  final String friendId;
  final String friendName;
  final String friendEmail;
  final String? friendPhotoUrl;
  final int friendGmrPoints;
  final String friendMedalLevel;
  final List<String> friendSports;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FriendModel({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendName,
    required this.friendEmail,
    this.friendPhotoUrl,
    required this.friendGmrPoints,
    required this.friendMedalLevel,
    required this.friendSports,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create model from Firestore document
  factory FriendModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return FriendModel(
      id: docId,
      userId: data['userId'] ?? '',
      friendId: data['friendId'] ?? '',
      friendName: data['friendName'] ?? 'Unknown',
      friendEmail: data['friendEmail'] ?? '',
      friendPhotoUrl: data['friendPhotoUrl'],
      friendGmrPoints: data['friendGmrPoints'] ?? 0,
      friendMedalLevel: data['friendMedalLevel'] ?? 'Bronze',
      friendSports: List<String>.from(data['friendSports'] ?? []),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert model to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'friendId': friendId,
      'friendName': friendName,
      'friendEmail': friendEmail,
      'friendPhotoUrl': friendPhotoUrl,
      'friendGmrPoints': friendGmrPoints,
      'friendMedalLevel': friendMedalLevel,
      'friendSports': friendSports,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Convert model to domain entity
  FriendEntity toEntity() {
    return FriendEntity(
      id: id,
      userId: userId,
      friendId: friendId,
      friendName: friendName,
      friendEmail: friendEmail,
      friendPhotoUrl: friendPhotoUrl,
      friendGmrPoints: friendGmrPoints,
      friendMedalLevel: friendMedalLevel,
      friendSports: friendSports,
      status: status.toFriendshipStatus(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from domain entity
  factory FriendModel.fromEntity(FriendEntity entity) {
    return FriendModel(
      id: entity.id,
      userId: entity.userId,
      friendId: entity.friendId,
      friendName: entity.friendName,
      friendEmail: entity.friendEmail,
      friendPhotoUrl: entity.friendPhotoUrl,
      friendGmrPoints: entity.friendGmrPoints,
      friendMedalLevel: entity.friendMedalLevel,
      friendSports: entity.friendSports,
      status: entity.status.toString().split('.').last,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}