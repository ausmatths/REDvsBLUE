// lib/features/profile/data/repositories/match_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_data_source.dart';
import '../models/match_model.dart';

/// Implementation of MatchRepository
///
/// Handles error transformation and delegates to data source
class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;

  MatchRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MatchEntity>>> getUserMatches(
      String userId,
      ) async {
    try {
      final matches = await remoteDataSource.getUserMatches(userId);
      return Right(matches.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getUserMatchesBySport(
      String userId,
      String sport,
      ) async {
    try {
      final matches = await remoteDataSource.getUserMatchesBySport(
        userId,
        sport,
      );
      return Right(matches.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatchById(String matchId) async {
    try {
      final match = await remoteDataSource.getMatchById(matchId);
      return Right(match.toEntity());
    } catch (e) {
      if (e.toString().contains('not found')) {
        return Left(NotFoundFailure(message: 'Match not found'));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> createMatch(MatchEntity match) async {
    try {
      final model = MatchModel.fromEntity(match);
      final createdMatch = await remoteDataSource.createMatch(model);
      return Right(createdMatch.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<MatchEntity>>> watchUserMatches(
      String userId,
      ) {
    try {
      return remoteDataSource.watchUserMatches(userId).map(
            (matches) => Right<Failure, List<MatchEntity>>(
          matches.map((model) => model.toEntity()).toList(),
        ),
      );
    } catch (e) {
      return Stream.value(
        Left(ServerFailure(message: e.toString())),
      );
    }
  }
}