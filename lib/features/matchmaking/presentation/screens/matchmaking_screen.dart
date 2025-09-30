import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/sport_card.dart'; // Import the new widget

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Match'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: const <Widget>[
            SportCard(
              sportName: 'Badminton',
              icon: FontAwesomeIcons.tableTennisPaddleBall, // Example icon
              color: Colors.blueAccent,
            ),
            SportCard(
              sportName: 'Football',
              icon: FontAwesomeIcons.futbol,
              color: Colors.green,
            ),
            SportCard(
              sportName: 'Cricket',
              icon: FontAwesomeIcons.baseball, // Example icon
              color: Colors.orange,
            ),
            SportCard(
              sportName: 'Pickleball',
              icon: FontAwesomeIcons.volleyball, // Example icon
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}