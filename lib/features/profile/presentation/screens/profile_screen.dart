// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    const String playerName = "Austin Matthews";
    const String playerRank = "Gold III";
    const int gmrPoints = 1250;
    const int wins = 42;
    const int losses = 18;
    const double winRate = (wins / (wins + losses)) * 100;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Player Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            // ### Profile Header ###
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200], // Light grey background
                    // Using FadeInImage to handle image loading and errors
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/default_avatar.png', // Your local fallback image
                        image: 'https://picsum.photos/150', // A more reliable placeholder service
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        imageErrorBuilder: (context, error, stackTrace) {
                          // This is the widget that will be shown if the network image fails to load
                          return Image.asset(
                            'assets/images/default_avatar.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        playerRank,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ### Tab Bar ###
            const TabBar(
              tabs: [
                Tab(text: 'Stats'),
                Tab(text: 'Match History'),
              ],
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.redAccent,
            ),

            // ### Tab Bar View ###
            Expanded(
              child: TabBarView(
                children: [
                  // --- Stats Tab ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      // FIXED: Removed the 'const' keyword from the list below
                      children: [
                        StatCard(
                          title: 'GMR Points',
                          value: '$gmrPoints',
                          icon: Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        StatCard(
                          title: 'Wins',
                          value: '$wins',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        StatCard(
                          title: 'Losses',
                          value: '$losses',
                          icon: Icons.highlight_off,
                          color: Colors.red,
                        ),
                        StatCard(
                          title: 'Win Rate',
                          value: '${winRate.toStringAsFixed(1)}%',
                          icon: FontAwesomeIcons.percent,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  // --- Match History Tab ---
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.sports_tennis),
                        title: Text('Win vs Player ${index + 2}'),
                        subtitle: const Text('Badminton - Ranked Match'),
                        trailing: Text(
                          '${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}