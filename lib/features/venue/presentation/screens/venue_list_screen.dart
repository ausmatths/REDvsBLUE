import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/venue_card.dart'; // Import the new widget

class VenueListScreen extends StatelessWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for venues
    final List<Map<String, dynamic>> venues = [
      {
        'name': 'Arena Sports Magnuson',
        'distance': '2.1 km',
        'rating': 4.5,
        'imageUrl': 'https://picsum.photos/seed/venue1/400/200',
        'sportIcons': [FontAwesomeIcons.futbol, FontAwesomeIcons.volleyball],
      },
      {
        'name': 'Seattle Badminton Club',
        'distance': '3.5 km',
        'rating': 4.8,
        'imageUrl': 'https://picsum.photos/seed/venue2/400/200',
        'sportIcons': [FontAwesomeIcons.tableTennisPaddleBall],
      },
      {
        'name': 'Interbay Cricket Pitch',
        'distance': '5.0 km',
        'rating': 4.2,
        'imageUrl': 'https://picsum.photos/seed/venue3/400/200',
        'sportIcons': [FontAwesomeIcons.baseball],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Venue'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return VenueCard(
            name: venue['name'],
            distance: venue['distance'],
            rating: venue['rating'],
            imageUrl: venue['imageUrl'],
            sportIcons: venue['sportIcons'],
          );
        },
      ),
    );
  }
}