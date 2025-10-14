// lib/features/profile/data/datasources/match_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';

/// Remote data source for match operations using Firestore
///
/// Handles all Firestore operations for match history
abstract class MatchRemoteDataSource {
  Future<List<MatchModel>> getUserMatches(String userId);
  Future<List<MatchModel>> getUserMatchesBySport(String userId, String sport);
  Future<MatchModel> getMatchById(String matchId);
  Future<MatchModel> createMatch(MatchModel match);
  Stream<List<MatchModel>> watchUserMatches(String userId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final FirebaseFirestore firestore;

  MatchRemoteDataSourceImpl({
    required this.firestore,
  });

  /// Collection reference for matches
  CollectionReference get _matchesCollection =>
      firestore.collection('matches');

  @override
  Future<List<MatchModel>> getUserMatches(String userId) async {
    try {
      // Query matches where user is either player1 or player2
      final query1 = await _matchesCollection
          .where('player1Id', isEqualTo: userId)
          .orderBy('matchDate', descending: true)
          .limit(50)
          .get();

      final query2 = await _matchesCollection
          .where('player2Id', isEqualTo: userId)
          .orderBy('matchDate', descending: true)
          .limit(50)
          .get();

      // Combine results and remove duplicates
      final allDocs = <String, DocumentSnapshot>{};

      for (var doc in query1.docs) {
        allDocs[doc.id] = doc;
      }

      for (var doc in query2.docs) {
        allDocs[doc.id] = doc;
      }

      // Convert to models and sort by date
      final matches = allDocs.values
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();

      matches.sort((a, b) => b.matchDate.compareTo(a.matchDate));

      return matches;
    } catch (e) {
      throw Exception('Failed to get user matches: $e');
    }
  }

  @override
  Future<List<MatchModel>> getUserMatchesBySport(
      String userId,
      String sport,
      ) async {
    try {
      // Get all user matches first
      final allMatches = await getUserMatches(userId);

      // Filter by sport
      return allMatches
          .where((match) => match.sport.toLowerCase() == sport.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Failed to get user matches by sport: $e');
    }
  }

  @override
  Future<MatchModel> getMatchById(String matchId) async {
    try {
      final doc = await _matchesCollection.doc(matchId).get();

      if (!doc.exists) {
        throw Exception('Match not found: $matchId');
      }

      return MatchModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get match: $e');
    }
  }

  @override
  Future<MatchModel> createMatch(MatchModel match) async {
    try {
      final docRef = _matchesCollection.doc();
      final newMatch = MatchModel(
        id: docRef.id,
        sport: match.sport,
        player1Id: match.player1Id,
        player1Name: match.player1Name,
        player1Photo: match.player1Photo,
        player2Id: match.player2Id,
        player2Name: match.player2Name,
        player2Photo: match.player2Photo,
        winnerId: match.winnerId,
        player1Outcome: match.player1Outcome,
        player2Outcome: match.player2Outcome,
        score: match.score,
        venue: match.venue,
        venueId: match.venueId,
        matchDate: match.matchDate,
        matchType: match.matchType,
        player1GmrChange: match.player1GmrChange,
        player2GmrChange: match.player2GmrChange,
        additionalStats: match.additionalStats,
      );

      await docRef.set(newMatch.toFirestore());
      return newMatch;
    } catch (e) {
      throw Exception('Failed to create match: $e');
    }
  }

  @override
  Stream<List<MatchModel>> watchUserMatches(String userId) {
    try {
      // This is a simplified version. For production, you might want to
      // combine streams from both player1 and player2 queries
      return _matchesCollection
          .where('player1Id', isEqualTo: userId)
          .orderBy('matchDate', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => MatchModel.fromFirestore(doc)).toList());
    } catch (e) {
      throw Exception('Failed to watch user matches: $e');
    }
  }
}