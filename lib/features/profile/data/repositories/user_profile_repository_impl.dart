// lib/features/profile/data/repositories/user_profile_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

/// Implementation of UserProfileRepository
///
/// Handles error transformation and delegates to data source
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> createProfile(
      UserProfileEntity profile,
      ) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await remoteDataSource.createProfile(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile(String userId) async {
    try {
      final result = await remoteDataSource.getProfile(userId);
      return Right(result.toEntity());
    } catch (e) {
      if (e.toString().contains('Profile not found')) {
        return Left(NotFoundFailure(message: 'Profile not found'));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
      UserProfileEntity profile,
      ) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await remoteDataSource.updateProfile(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateMatchStats({
    required String userId,
    required MatchResult result,
  }) async {
    try {
      final dataSource = remoteDataSource as UserProfileRemoteDataSourceImpl;
      final updatedProfile = await dataSource.updateMatchStats(
        userId: userId,
        result: result,
      );
      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> addAchievement({
    required String userId,
    required Achievement achievement,
  }) async {
    try {
      final dataSource = remoteDataSource as UserProfileRemoteDataSourceImpl;
      final updatedProfile = await dataSource.addAchievement(
        userId: userId,
        achievement: achievement,
      );
      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateSports({
    required String userId,
    required List<String> sports,
  }) async {
    try {
      final dataSource = remoteDataSource as UserProfileRemoteDataSourceImpl;
      final updatedProfile = await dataSource.updateSports(
        userId: userId,
        sports: sports,
      );
      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> profileExists(String userId) async {
    try {
      final exists = await remoteDataSource.profileExists(userId);
      return Right(exists);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, UserProfileEntity>> watchProfile(String userId) {
    try {
      return remoteDataSource.watchProfile(userId).map(
            (profile) => Right<Failure, UserProfileEntity>(profile.toEntity()),
      );
    } catch (e) {
      return Stream.value(
        Left(ServerFailure(message: e.toString())),
      );
    }
  }
}