import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/friend_entity.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

/// Data model for Friend with JSON serialization
/// Converts between API/Firebase data and domain entities
@freezed
class FriendModel with _$FriendModel {
  const factory FriendModel({
    required String id,
    required String userId,
    required String friendId,
    required String friendName,
    String? friendPhotoUrl,
    required String friendEmail,
    required String status,
    required DateTime createdAt,
    DateTime? acceptedAt,
    @Default(0) int friendGmrPoints,
    @Default('Bronze') String friendMedalLevel,
    @Default([]) List<String> friendSports,
  }) = _FriendModel;

  const FriendModel._();

  /// Create from JSON
  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  /// Convert from domain entity
  factory FriendModel.fromEntity(FriendEntity entity) {
    return FriendModel(
      id: entity.id,
      userId: entity.userId,
      friendId: entity.friendId,
      friendName: entity.friendName,
      friendPhotoUrl: entity.friendPhotoUrl,
      friendEmail: entity.friendEmail,
      status: entity.status.toJson(),
      createdAt: entity.createdAt,
      acceptedAt: entity.acceptedAt,
      friendGmrPoints: entity.friendGmrPoints,
      friendMedalLevel: entity.friendMedalLevel,
      friendSports: entity.friendSports,
    );
  }

  /// Convert to domain entity
  FriendEntity toEntity() {
    return FriendEntity(
      id: id,
      userId: userId,
      friendId: friendId,
      friendName: friendName,
      friendPhotoUrl: friendPhotoUrl,
      friendEmail: friendEmail,
      status: FriendshipStatusExtension.fromJson(status),
      createdAt: createdAt,
      acceptedAt: acceptedAt,
      friendGmrPoints: friendGmrPoints,
      friendMedalLevel: friendMedalLevel,
      friendSports: friendSports,
    );
  }

  /// Create from Firestore document
  factory FriendModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return FriendModel(
      id: docId,
      userId: data['userId'] as String? ?? '',
      friendId: data['friendId'] as String? ?? '',
      friendName: data['friendName'] as String? ?? '',
      friendPhotoUrl: data['friendPhotoUrl'] as String?,
      friendEmail: data['friendEmail'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      acceptedAt: data['acceptedAt'] != null
          ? DateTime.parse(data['acceptedAt'] as String)
          : null,
      friendGmrPoints: data['friendGmrPoints'] as int? ?? 0,
      friendMedalLevel: data['friendMedalLevel'] as String? ?? 'Bronze',
      friendSports: data['friendSports'] != null
          ? List<String>.from(data['friendSports'] as List)
          : [],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'friendId': friendId,
      'friendName': friendName,
      'friendPhotoUrl': friendPhotoUrl,
      'friendEmail': friendEmail,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'friendGmrPoints': friendGmrPoints,
      'friendMedalLevel': friendMedalLevel,
      'friendSports': friendSports,
    };
  }
}