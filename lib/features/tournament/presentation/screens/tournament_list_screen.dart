import 'package:flutter/material.dart';

class TournamentListScreen extends StatelessWidget {
  const TournamentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournaments')),
      body: const Center(child: Text('Tournament List')),
    );
  }
}

class TournamentDetailsScreen extends StatelessWidget {
  final String tournamentId;
  const TournamentDetailsScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Details')),
      body: Center(child: Text('Tournament ID: $tournamentId')),
    );
  }
}

class TournamentBracketScreen extends StatelessWidget {
  final String tournamentId;
  const TournamentBracketScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Bracket')),
      body: Center(child: Text('Bracket for: $tournamentId')),
    );
  }
}