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
    // Business validation
    if (userId == friendId) {
      return Left(ValidationFailure(message: 'Cannot send friend request to yourself'));
    }

    if (userId.isEmpty || friendId.isEmpty) {
      return Left(ValidationFailure(message: 'User IDs cannot be empty'));
    }

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
    if (requestId.isEmpty) {
      return Left(ValidationFailure(message: 'Request ID cannot be empty'));
    }

    return await repository.acceptFriendRequest(requestId);
  }
}

/// Use case for rejecting a friend request
class RejectFriendRequest {
  final FriendsRepository repository;

  RejectFriendRequest(this.repository);

  Future<Either<Failure, void>> call(String requestId) async {
    if (requestId.isEmpty) {
      return Left(ValidationFailure(message: 'Request ID cannot be empty'));
    }

    return await repository.rejectFriendRequest(requestId);
  }
}

/// Use case for removing a friend
class RemoveFriend {
  final FriendsRepository repository;

  RemoveFriend(this.repository);

  Future<Either<Failure, void>> call(String friendshipId) async {
    if (friendshipId.isEmpty) {
      return Left(ValidationFailure(message: 'Friendship ID cannot be empty'));
    }

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
    // Business validation
    if (userId == blockedUserId) {
      return Left(ValidationFailure(message: 'Cannot block yourself'));
    }

    if (userId.isEmpty || blockedUserId.isEmpty) {
      return Left(ValidationFailure(message: 'User IDs cannot be empty'));
    }

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
    // Business validation
    if (query.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Search query cannot be empty'));
    }

    if (query.trim().length < 2) {
      return Left(ValidationFailure(message: 'Search query must be at least 2 characters'));
    }

    return await repository.searchUsers(
      query: query.trim(),
      currentUserId: currentUserId,
    );
  }
}

/// Use case for watching friends in real-time
class WatchFriends {
  final FriendsRepository repository;

  WatchFriends(this.repository);

  Stream<Either<Failure, List<FriendEntity>>> call(String userId) {
    if (userId.isEmpty) {
      return Stream.value(
        Left(ValidationFailure(message: 'User ID cannot be empty')),
      );
    }

    return repository.watchFriends(userId);
  }
}