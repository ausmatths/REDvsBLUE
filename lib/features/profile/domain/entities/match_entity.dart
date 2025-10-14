// lib/features/profile/domain/entities/match_entity.dart

import 'package:equatable/equatable.dart';
import 'user_profile_entity.dart';

/// Represents a completed sports match
///
/// This is the core domain entity for match history
class MatchEntity extends Equatable {
  final String id;
  final String sport;
  final String player1Id;
  final String player1Name;
  final String? player1Photo;
  final String player2Id;
  final String player2Name;
  final String? player2Photo;
  final String winnerId;
  final MatchOutcome player1Outcome;
  final MatchOutcome player2Outcome;
  final String score;
  final String venue;
  final String? venueId;
  final DateTime matchDate;
  final String matchType; // 'casual', 'ranked', 'tournament'
  final int player1GmrChange;
  final int player2GmrChange;
  final Map<String, dynamic>? additionalStats;

  const MatchEntity({
    required this.id,
    required this.sport,
    required this.player1Id,
    required this.player1Name,
    this.player1Photo,
    required this.player2Id,
    required this.player2Name,
    this.player2Photo,
    required this.winnerId,
    required this.player1Outcome,
    required this.player2Outcome,
    required this.score,
    required this.venue,
    this.venueId,
    required this.matchDate,
    required this.matchType,
    required this.player1GmrChange,
    required this.player2GmrChange,
    this.additionalStats,
  });

  /// Get opponent info for a specific player
  ({String name, String? photo, MatchOutcome outcome, int gmrChange}) getOpponentInfo(String userId) {
    if (userId == player1Id) {
      return (
      name: player2Name,
      photo: player2Photo,
      outcome: player1Outcome,
      gmrChange: player1GmrChange,
      );
    } else {
      return (
      name: player1Name,
      photo: player1Photo,
      outcome: player2Outcome,
      gmrChange: player2GmrChange,
      );
    }
  }

  /// Check if this match was a win for the given player
  bool isWinForPlayer(String userId) {
    if (userId == player1Id) {
      return player1Outcome == MatchOutcome.win;
    } else if (userId == player2Id) {
      return player2Outcome == MatchOutcome.win;
    }
    return false;
  }

  /// Check if this match was a loss for the given player
  bool isLossForPlayer(String userId) {
    if (userId == player1Id) {
      return player1Outcome == MatchOutcome.loss;
    } else if (userId == player2Id) {
      return player2Outcome == MatchOutcome.loss;
    }
    return false;
  }

  @override
  List<Object?> get props => [
    id,
    sport,
    player1Id,
    player1Name,
    player1Photo,
    player2Id,
    player2Name,
    player2Photo,
    winnerId,
    player1Outcome,
    player2Outcome,
    score,
    venue,
    venueId,
    matchDate,
    matchType,
    player1GmrChange,
    player2GmrChange,
    additionalStats,
  ];
}