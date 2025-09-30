// lib/features/matchmaking/presentation/screens/match_search_screen.dart

import 'package:flutter/material.dart';

class MatchSearchScreen extends StatelessWidget {
  // ADDED: A field to hold the sport name passed from the router.
  final String sport;

  // FIXED: The constructor now accepts the required 'sport' parameter.
  // The 'const' keyword was also removed.
  const MatchSearchScreen({
    super.key,
    required this.sport,
  });

  @override
  Widget build(BuildContext context) {
    // We can now use the 'sport' variable in our UI.
    final capitalizedSport = sport[0].toUpperCase() + sport.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Searching for $capitalizedSport Match...'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Finding a worthy opponent!'),
          ],
        ),
      ),
    );
  }
}