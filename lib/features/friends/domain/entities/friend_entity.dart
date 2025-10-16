import 'package:equatable/equatable.dart';

/// Represents a friend relationship between two users
/// This is a domain entity with no Flutter dependencies
class FriendEntity extends Equatable {
  final String id;
  final String userId;  // The user who initiated the friend request
  final String friendId;  // The user who received the request
  final String friendName;
  final String? friendPhotoUrl;
  final String friendEmail;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;

  // Friend stats for display
  final int friendGmrPoints;
  final String friendMedalLevel;
  final List<String> friendSports;

  const FriendEntity({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendName,
    this.friendPhotoUrl,
    required this.friendEmail,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    required this.friendGmrPoints,
    required this.friendMedalLevel,
    required this.friendSports,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    friendId,
    friendName,
    friendPhotoUrl,
    friendEmail,
    status,
    createdAt,
    acceptedAt,
    friendGmrPoints,
    friendMedalLevel,
    friendSports,
  ];

  /// Creates a copy with modified fields
  FriendEntity copyWith({
    String? id,
    String? userId,
    String? friendId,
    String? friendName,
    String? friendPhotoUrl,
    String? friendEmail,
    FriendshipStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    int? friendGmrPoints,
    String? friendMedalLevel,
    List<String>? friendSports,
  }) {
    return FriendEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      friendName: friendName ?? this.friendName,
      friendPhotoUrl: friendPhotoUrl ?? this.friendPhotoUrl,
      friendEmail: friendEmail ?? this.friendEmail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      friendGmrPoints: friendGmrPoints ?? this.friendGmrPoints,
      friendMedalLevel: friendMedalLevel ?? this.friendMedalLevel,
      friendSports: friendSports ?? this.friendSports,
    );
  }
}

/// Status of a friendship
enum FriendshipStatus {
  pending,   // Friend request sent but not accepted
  accepted,  // Friend request accepted
  blocked,   // User has blocked this person
}

/// Extension to convert string to enum
extension FriendshipStatusExtension on FriendshipStatus {
  String toJson() {
    return toString().split('.').last;
  }

  static FriendshipStatus fromJson(String value) {
    return FriendshipStatus.values.firstWhere(
          (status) => status.toString().split('.').last == value,
      orElse: () => FriendshipStatus.pending,
    );
  }
}