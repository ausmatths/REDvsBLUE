import 'package:flutter/material.dart';
// ADDED: Import all the screens used in the bottom navigation bar
import 'package:redvsblue/features/matchmaking/presentation/screens/matchmaking_screen.dart';
import 'package:redvsblue/features/profile/presentation/screens/profile_screen.dart';
import 'package:redvsblue/features/ranking/presentation/screens/leaderboard_screen.dart';
import 'package:redvsblue/features/tournament/presentation/screens/tournament_list_screen.dart';
import 'package:redvsblue/features/venue/presentation/screens/venue_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // FIXED: Removed 'const' because the list contains non-constant widgets
  static final List<Widget> _widgetOptions = <Widget>[
    const MatchmakingScreen(), // Main dashboard/matchmaking
    const VenueListScreen(),
    const TournamentListScreen(),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis),
            label: 'Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Tournaments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}