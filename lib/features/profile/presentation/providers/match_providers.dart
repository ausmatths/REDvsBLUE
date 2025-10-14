// lib/features/profile/presentation/providers/match_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/match_remote_data_source.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import 'user_profile_providers.dart';

part 'match_providers.g.dart';

// ============================================================================
// Infrastructure Providers
// ============================================================================

/// Provides Match remote data source
@riverpod
MatchRemoteDataSource matchRemoteDataSource(MatchRemoteDataSourceRef ref) {
  return MatchRemoteDataSourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// Provides Match repository
@riverpod
MatchRepository matchRepository(MatchRepositoryRef ref) {
  return MatchRepositoryImpl(
    remoteDataSource: ref.watch(matchRemoteDataSourceProvider),
  );
}

// ============================================================================
// Match Data Providers
// ============================================================================

/// Fetches all matches for a user
@riverpod
Future<List<MatchEntity>> userMatches(
    UserMatchesRef ref,
    String userId,
    ) async {
  final repository = ref.watch(matchRepositoryProvider);
  final result = await repository.getUserMatches(userId);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (matches) => matches,
  );
}

/// Fetches matches for a user filtered by sport
@riverpod
Future<List<MatchEntity>> userMatchesBySport(
    UserMatchesBySportRef ref,
    String userId,
    String sport,
    ) async {
  final repository = ref.watch(matchRepositoryProvider);

  // If sport is 'All', return all matches
  if (sport.toLowerCase() == 'all') {
    return ref.watch(userMatchesProvider(userId).future);
  }

  final result = await repository.getUserMatchesBySport(userId, sport);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (matches) => matches,
  );
}

/// Fetches a single match by ID
@riverpod
Future<MatchEntity> matchById(
    MatchByIdRef ref,
    String matchId,
    ) async {
  final repository = ref.watch(matchRepositoryProvider);
  final result = await repository.getMatchById(matchId);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (match) => match,
  );
}

/// Watches user matches in real-time
@riverpod
Stream<List<MatchEntity>> watchUserMatches(
    WatchUserMatchesRef ref,
    String userId,
    ) {
  final repository = ref.watch(matchRepositoryProvider);

  return repository.watchUserMatches(userId).map(
        (either) => either.fold(
          (failure) => throw Exception(failure.message),
          (matches) => matches,
    ),
  );
}

// ============================================================================
// Stats Providers (Computed from matches)
// ============================================================================

/// Computes match statistics for a user
@riverpod
Future<MatchStats> userMatchStats(
    UserMatchStatsRef ref,
    String userId,
    ) async {
  final matches = await ref.watch(userMatchesProvider(userId).future);

  int totalMatches = matches.length;
  int wins = 0;
  int losses = 0;
  int draws = 0;

  for (final match in matches) {
    if (match.isWinForPlayer(userId)) {
      wins++;
    } else if (match.isLossForPlayer(userId)) {
      losses++;
    } else {
      draws++;
    }
  }

  final winRate = totalMatches > 0 ? (wins / totalMatches * 100) : 0.0;

  return MatchStats(
    totalMatches: totalMatches,
    wins: wins,
    losses: losses,
    draws: draws,
    winRate: winRate,
  );
}

/// Computes match statistics by sport
@riverpod
Future<MatchStats> userMatchStatsBySport(
    UserMatchStatsBySportRef ref,
    String userId,
    String sport,
    ) async {
  final matches = await ref.watch(userMatchesBySportProvider(userId, sport).future);

  int totalMatches = matches.length;
  int wins = 0;
  int losses = 0;
  int draws = 0;

  for (final match in matches) {
    if (match.isWinForPlayer(userId)) {
      wins++;
    } else if (match.isLossForPlayer(userId)) {
      losses++;
    } else {
      draws++;
    }
  }

  final winRate = totalMatches > 0 ? (wins / totalMatches * 100) : 0.0;

  return MatchStats(
    totalMatches: totalMatches,
    wins: wins,
    losses: losses,
    draws: draws,
    winRate: winRate,
  );
}

// ============================================================================
// Helper Classes
// ============================================================================

/// Match statistics data class
class MatchStats {
  final int totalMatches;
  final int wins;
  final int losses;
  final int draws;
  final double winRate;

  MatchStats({
    required this.totalMatches,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winRate,
  });
}