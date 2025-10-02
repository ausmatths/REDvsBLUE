import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TournamentListScreen extends StatelessWidget {
  const TournamentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 100,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tournaments Coming Soon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.grey700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Exciting tournaments will be available here',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}