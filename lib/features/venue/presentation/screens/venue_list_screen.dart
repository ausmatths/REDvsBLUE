import 'package:flutter/material.dart';

class VenueListScreen extends StatelessWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: const Center(child: Text('Venue List')),
    );
  }
}

class VenueDetailsScreen extends StatelessWidget {
  final String venueId;
  const VenueDetailsScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Details')),
      body: Center(child: Text('Venue ID: $venueId')),
    );
  }
}

class VenueBookingScreen extends StatelessWidget {
  final String venueId;
  const VenueBookingScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Venue')),
      body: Center(child: Text('Booking Venue: $venueId')),
    );
  }
}