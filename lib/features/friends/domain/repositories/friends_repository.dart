import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/friend_entity.dart';

/// Repository interface for Friends operations
/// Implementation will be in the data layer
abstract class FriendsRepository {
  /// Get all friends for a specific user
  /// Returns [Right] with list of friends on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<FriendEntity>>> getFriends(String userId);

  /// Get pending friend requests for a user
  Future<Either<Failure, List<FriendEntity>>> getPendingRequests(String userId);

  /// Send a friend request to another user
  Future<Either<Failure, FriendEntity>> sendFriendRequest({
    required String userId,
    required String friendId,
  });

  /// Accept a friend request
  Future<Either<Failure, FriendEntity>> acceptFriendRequest(String requestId);

  /// Reject a friend request
  Future<Either<Failure, void>> rejectFriendRequest(String requestId);

  /// Remove a friend
  Future<Either<Failure, void>> removeFriend(String friendshipId);

  /// Block a user
  Future<Either<Failure, void>> blockUser({
    required String userId,
    required String blockedUserId,
  });

  /// Search for users by username or email
  Future<Either<Failure, List<FriendEntity>>> searchUsers({
    required String query,
    required String currentUserId,
  });

  /// Watch friends in real-time
  /// Returns a stream of friend lists that updates when data changes
  Stream<Either<Failure, List<FriendEntity>>> watchFriends(String userId);
}