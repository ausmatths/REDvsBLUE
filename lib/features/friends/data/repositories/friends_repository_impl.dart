import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_data_source.dart';

/// Implementation of FriendsRepository
/// Handles data operations and error conversion
class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource remoteDataSource;

  FriendsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends(String userId) async {
    try {
      final models = await remoteDataSource.getFriends(userId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getPendingRequests(
      String userId,
      ) async {
    try {
      final models = await remoteDataSource.getPendingRequests(userId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FriendEntity>> sendFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
      final model = await remoteDataSource.sendFriendRequest(
        userId: userId,
        friendId: friendId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on NotFoundExceptionCustom catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FriendEntity>> acceptFriendRequest(
      String requestId,
      ) async {
    try {
      final model = await remoteDataSource.acceptFriendRequest(requestId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundExceptionCustom catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectFriendRequest(String requestId) async {
    try {
      await remoteDataSource.rejectFriendRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFriend(String friendshipId) async {
    try {
      await remoteDataSource.removeFriend(friendshipId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await remoteDataSource.blockUser(
        userId: userId,
        blockedUserId: blockedUserId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> searchUsers({
    required String query,
    required String currentUserId,
  }) async {
    try {
      final models = await remoteDataSource.searchUsers(
        query: query,
        currentUserId: currentUserId,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<FriendEntity>>> watchFriends(String userId) {
    try {
      return remoteDataSource.watchFriends(userId).map((models) {
        final entities = models.map((model) => model.toEntity()).toList();
        return Right<Failure, List<FriendEntity>>(entities);
      }).handleError((error) {
        if (error is ServerException) {
          return Left<Failure, List<FriendEntity>>(
            ServerFailure(message: error.message),
          );
        }
        return Left<Failure, List<FriendEntity>>(
          UnknownFailure(message: error.toString()),
        );
      });
    } catch (e) {
      return Stream.value(
        Left(UnknownFailure(message: e.toString())),
      );
    }
  }
}