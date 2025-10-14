// lib/features/profile/domain/repositories/match_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';

/// Repository interface for match operations
///
/// Defines the contract without implementation details
abstract class MatchRepository {
  /// Fetches all matches for a user
  ///
  /// Returns [Right] with list of matches on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<MatchEntity>>> getUserMatches(String userId);

  /// Fetches matches for a user filtered by sport
  ///
  /// [userId]: ID of the user
  /// [sport]: Sport to filter by
  Future<Either<Failure, List<MatchEntity>>> getUserMatchesBySport(
      String userId,
      String sport,
      );

  /// Fetches a single match by ID
  ///
  /// [matchId]: ID of the match
  Future<Either<Failure, MatchEntity>> getMatchById(String matchId);

  /// Creates a new match record
  ///
  /// [match]: The match to create
  Future<Either<Failure, MatchEntity>> createMatch(MatchEntity match);

  /// Watches user matches in real-time
  ///
  /// Returns a stream of match lists
  Stream<Either<Failure, List<MatchEntity>>> watchUserMatches(String userId);
}