import 'package:equatable/equatable.dart';

/// Core entity representing a friend or friendship
/// This is a domain object - no dependencies on data layer
class FriendEntity extends Equatable {
  final String id; // Friendship document ID
  final String userId; // The user who sent/received the request
  final String friendId; // The other user in the friendship
  final String friendName;
  final String friendEmail;
  final String? friendPhotoUrl;
  final int friendGmrPoints;
  final String friendMedalLevel; // Bronze, Silver, Gold, Platinum
  final List<String> friendSports;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FriendEntity({
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

  /// Check if this is a pending request
  bool get isPending => status == FriendshipStatus.pending;

  /// Check if friendship is active
  bool get isAccepted => status == FriendshipStatus.accepted;

  /// Check if user is blocked
  bool get isBlocked => status == FriendshipStatus.blocked;

  /// Get medal emoji for display
  String get medalEmoji {
    switch (friendMedalLevel.toLowerCase()) {
      case 'bronze':
        return '🥉';
      case 'silver':
        return '🥈';
      case 'gold':
        return '🥇';
      case 'platinum':
        return '💎';
      default:
        return '🏅';
    }
  }

  /// Get sports emoji list
  String get sportsEmojis {
    final emojiMap = {
      'badminton': '🏸',
      'football': '⚽',
      'cricket': '🏏',
      'basketball': '🏀',
      'tennis': '🎾',
      'pickleball': '🥒',
    };

    return friendSports
        .map((sport) => emojiMap[sport.toLowerCase()] ?? '🏆')
        .join(' ');
  }

  /// Copy with method for immutability
  FriendEntity copyWith({
    String? id,
    String? userId,
    String? friendId,
    String? friendName,
    String? friendEmail,
    String? friendPhotoUrl,
    int? friendGmrPoints,
    String? friendMedalLevel,
    List<String>? friendSports,
    FriendshipStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FriendEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      friendName: friendName ?? this.friendName,
      friendEmail: friendEmail ?? this.friendEmail,
      friendPhotoUrl: friendPhotoUrl ?? this.friendPhotoUrl,
      friendGmrPoints: friendGmrPoints ?? this.friendGmrPoints,
      friendMedalLevel: friendMedalLevel ?? this.friendMedalLevel,
      friendSports: friendSports ?? this.friendSports,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    friendId,
    friendName,
    friendEmail,
    friendPhotoUrl,
    friendGmrPoints,
    friendMedalLevel,
    friendSports,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Enum for friendship status
enum FriendshipStatus {
  pending,   // Friend request sent but not yet accepted
  accepted,  // Friends
  rejected,  // Request was rejected
  blocked,   // User has blocked this person
}

/// Extension to convert string to enum
extension FriendshipStatusExtension on String {
  FriendshipStatus toFriendshipStatus() {
    switch (toLowerCase()) {
      case 'pending':
        return FriendshipStatus.pending;
      case 'accepted':
        return FriendshipStatus.accepted;
      case 'rejected':
        return FriendshipStatus.rejected;
      case 'blocked':
        return FriendshipStatus.blocked;
      default:
        return FriendshipStatus.pending;
    }
  }
}