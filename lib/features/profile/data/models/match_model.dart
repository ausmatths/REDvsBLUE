
// lib/features/profile/data/models/match_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/user_profile_entity.dart';

/// Data model for MatchEntity
///
/// Handles Firestore serialization/deserialization
class MatchModel {
  final String id;
  final String sport;
  final String player1Id;
  final String player1Name;
  final String? player1Photo;
  final String player2Id;
  final String player2Name;
  final String? player2Photo;
  final String winnerId;
  final String player1Outcome;
  final String player2Outcome;
  final String score;
  final String venue;
  final String? venueId;
  final DateTime matchDate;
  final String matchType;
  final int player1GmrChange;
  final int player2GmrChange;
  final Map<String, dynamic>? additionalStats;

  const MatchModel({
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

  /// Convert entity to model
  factory MatchModel.fromEntity(MatchEntity entity) {
    return MatchModel(
      id: entity.id,
      sport: entity.sport,
      player1Id: entity.player1Id,
      player1Name: entity.player1Name,
      player1Photo: entity.player1Photo,
      player2Id: entity.player2Id,
      player2Name: entity.player2Name,
      player2Photo: entity.player2Photo,
      winnerId: entity.winnerId,
      player1Outcome: entity.player1Outcome.name,
      player2Outcome: entity.player2Outcome.name,
      score: entity.score,
      venue: entity.venue,
      venueId: entity.venueId,
      matchDate: entity.matchDate,
      matchType: entity.matchType,
      player1GmrChange: entity.player1GmrChange,
      player2GmrChange: entity.player2GmrChange,
      additionalStats: entity.additionalStats,
    );
  }

  /// Convert model to entity
  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      sport: sport,
      player1Id: player1Id,
      player1Name: player1Name,
      player1Photo: player1Photo,
      player2Id: player2Id,
      player2Name: player2Name,
      player2Photo: player2Photo,
      winnerId: winnerId,
      player1Outcome: _parseOutcome(player1Outcome),
      player2Outcome: _parseOutcome(player2Outcome),
      score: score,
      venue: venue,
      venueId: venueId,
      matchDate: matchDate,
      matchType: matchType,
      player1GmrChange: player1GmrChange,
      player2GmrChange: player2GmrChange,
      additionalStats: additionalStats,
    );
  }

  /// Create model from Firestore document
  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MatchModel(
      id: doc.id,
      sport: data['sport'] ?? '',
      player1Id: data['player1Id'] ?? '',
      player1Name: data['player1Name'] ?? '',
      player1Photo: data['player1Photo'],
      player2Id: data['player2Id'] ?? '',
      player2Name: data['player2Name'] ?? '',
      player2Photo: data['player2Photo'],
      winnerId: data['winnerId'] ?? '',
      player1Outcome: data['player1Outcome'] ?? 'loss',
      player2Outcome: data['player2Outcome'] ?? 'loss',
      score: data['score'] ?? '',
      venue: data['venue'] ?? '',
      venueId: data['venueId'],
      matchDate: (data['matchDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      matchType: data['matchType'] ?? 'casual',
      player1GmrChange: data['player1GmrChange'] ?? 0,
      player2GmrChange: data['player2GmrChange'] ?? 0,
      additionalStats: data['additionalStats'] as Map<String, dynamic>?,
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'sport': sport,
      'player1Id': player1Id,
      'player1Name': player1Name,
      'player1Photo': player1Photo,
      'player2Id': player2Id,
      'player2Name': player2Name,
      'player2Photo': player2Photo,
      'winnerId': winnerId,
      'player1Outcome': player1Outcome,
      'player2Outcome': player2Outcome,
      'score': score,
      'venue': venue,
      'venueId': venueId,
      'matchDate': Timestamp.fromDate(matchDate),
      'matchType': matchType,
      'player1GmrChange': player1GmrChange,
      'player2GmrChange': player2GmrChange,
      'additionalStats': additionalStats,
    };
  }

  /// Parse outcome string to enum
  MatchOutcome _parseOutcome(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'win':
        return MatchOutcome.win;
      case 'loss':
        return MatchOutcome.loss;
      case 'draw':
        return MatchOutcome.draw;
      default:
        return MatchOutcome.loss;
    }
  }
}