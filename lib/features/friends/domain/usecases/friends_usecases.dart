import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/friend_entity.dart';
import '../repositories/friends_repository.dart';

/// Use case for getting a user's friends list
class GetFriends {
  final FriendsRepository repository;

  GetFriends(this.repository);

  Future<Either<Failure, List<FriendEntity>>> call(String userId) async {
    return await repository.getFriends(userId);
  }
}

/// Use case for getting pending friend requests
class GetPendingRequests {
  final FriendsRepository repository;

  GetPendingRequests(this.repository);

  Future<Either<Failure, List<FriendEntity>>> call(String userId) async {
    return await repository.getPendingRequests(userId);
  }
}

/// Use case for sending a friend request
class SendFriendRequest {
  final FriendsRepository repository;

  SendFriendRequest(this.repository);

  Future<Either<Failure, FriendEntity>> call({
    required String userId,
    required String friendId,
  }) async {
    return await repository.sendFriendRequest(
      userId: userId,
      friendId: friendId,
    );
  }
}

/// Use case for accepting a friend request
class AcceptFriendRequest {
  final FriendsRepository repository;

  AcceptFriendRequest(this.repository);

  Future<Either<Failure, FriendEntity>> call(String requestId) async {
    return await repository.acceptFriendRequest(requestId);
  }
}

/// Use case for rejecting a friend request
class RejectFriendRequest {
  final FriendsRepository repository;

  RejectFriendRequest(this.repository);

  Future<Either<Failure, void>> call(String requestId) async {
    return await repository.rejectFriendRequest(requestId);
  }
}

/// Use case for removing a friend
class RemoveFriend {
  final FriendsRepository repository;

  RemoveFriend(this.repository);

  Future<Either<Failure, void>> call(String friendshipId) async {
    return await repository.removeFriend(friendshipId);
  }
}

/// Use case for blocking a user
class BlockUser {
  final FriendsRepository repository;

  BlockUser(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String blockedUserId,
  }) async {
    return await repository.blockUser(
      userId: userId,
      blockedUserId: blockedUserId,
    );
  }
}

/// Use case for searching users
class SearchUsers {
  final FriendsRepository repository;

  SearchUsers(this.repository);

  Future<Either<Failure, List<FriendEntity>>> call({
    required String query,
    required String currentUserId,
  }) async {
    return await repository.searchUsers(
      query: query,
      currentUserId: currentUserId,
    );
  }
}

/// Use case for watching friends in real-time
class WatchFriends {
  final FriendsRepository repository;

  WatchFriends(this.repository);

  Stream<Either<Failure, List<FriendEntity>>> call(String userId) {
    return repository.watchFriends(userId);
  }
}