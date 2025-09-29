import 'package:flutter/material.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matchmaking')),
      body: const Center(child: Text('Find Opponents')),
    );
  }
}

class MatchSearchScreen extends StatelessWidget {
  const MatchSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Match')),
      body: const Center(child: Text('Searching...')),
    );
  }
}

class MatchDetailsScreen extends StatelessWidget {
  final String matchId;
  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Details')),
      body: Center(child: Text('Match ID: $matchId')),
    );
  }
}