// lib/features/matchmaking/presentation/screens/match_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'dart:async';

class MatchSearchScreen extends StatefulWidget {
  final String sport;
  const MatchSearchScreen({super.key, required this.sport});

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreenState();
}

class _MatchSearchScreenState extends State<MatchSearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  Timer? _searchTimer;

  bool _isSearching = true;
  bool _matchFound = false;
  Map<String, dynamic>? _matchedPlayer;

  final List<Map<String, dynamic>> _mockPlayers = [
    {
      'name': 'Alex Johnson',
      'rating': 'Gold III',
      'gmr': 1245,
      'distance': '2.3 km',
      'winRate': '68%',
      'matches': 156,
      'avatar': '👤',
    },
    {
      'name': 'Sarah Chen',
      'rating': 'Gold II',
      'gmr': 1180,
      'distance': '1.8 km',
      'winRate': '72%',
      'matches': 203,
      'avatar': '👩',
    },
    {
      'name': 'Mike Williams',
      'rating': 'Silver I',
      'gmr': 985,
      'distance': '3.1 km',
      'winRate': '54%',
      'matches': 89,
      'avatar': '🧑',
    },
    {
      'name': 'Priya Patel',
      'rating': 'Gold I',
      'gmr': 1105,
      'distance': '2.7 km',
      'winRate': '61%',
      'matches': 142,
      'avatar': '👤',
    },
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Simulate finding a match after 3-5 seconds
    _searchTimer = Timer(
      Duration(seconds: 3 + math.Random().nextInt(3)),
          () {
        if (mounted) {
          setState(() {
            _matchedPlayer = _mockPlayers[math.Random().nextInt(_mockPlayers.length)];
            _matchFound = true;
            _isSearching = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Finding ${_getSportName()} Match',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Animated background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0E27),
                  Colors.red.shade900.withOpacity(0.3),
                  Colors.blue.shade900.withOpacity(0.3),
                ],
              ),
            ),
          ),

          // Main content
          if (_isSearching)
            _buildSearchingView()
          else if (_matchFound && _matchedPlayer != null)
            _buildMatchFoundView(),
        ],
      ),
    );
  }

  Widget _buildSearchingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Radar animation
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Radar circles
                ..._buildRadarCircles(),

                // Scanning line
                AnimatedBuilder(
                  animation: _radarController,
                  builder: (_, __) {
                    return Transform.rotate(
                      angle: _radarController.value * 2 * math.pi,
                      child: Container(
                        width: 2,
                        height: 125,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.greenAccent.withOpacity(0),
                              Colors.greenAccent.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Center sport icon with pulse animation
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.9 + (_pulseController.value * 0.2),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.blue.shade400,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _getSportIcon(),
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Search status text
          Text(
            'Searching for opponents...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).fadeIn(duration: 1.seconds).then().fadeOut(duration: 1.seconds),

          const SizedBox(height: 20),

          // Player count animation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: Colors.greenAccent.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                '${3 + math.Random().nextInt(8)} players nearby',
                style: TextStyle(
                  color: Colors.greenAccent.shade400,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Cancel button
          TextButton(
            onPressed: () {
              _searchTimer?.cancel();
              context.pop();
            },
            child: Text(
              'Cancel Search',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchFoundView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Match found animation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.greenAccent, width: 2),
            ),
            child: const Text(
              'MATCH FOUND!',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ).animate()
              .scaleXY(duration: 500.ms, begin: 0)
              .fadeIn(),

          const SizedBox(height: 40),

          // Player card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.blue.shade400],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _matchedPlayer!['avatar'],
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Name and rating
                Text(
                  _matchedPlayer!['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber, width: 1),
                  ),
                  child: Text(
                    '${_matchedPlayer!['rating']} • ${_matchedPlayer!['gmr']} GMR',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(Icons.location_on, _matchedPlayer!['distance']),
                    _buildStatItem(Icons.emoji_events, _matchedPlayer!['winRate']),
                    _buildStatItem(Icons.sports, '${_matchedPlayer!['matches']}'),
                  ],
                ),
              ],
            ),
          ).animate()
              .slideY(begin: 0.2, duration: 600.ms)
              .fadeIn(),

          const SizedBox(height: 40),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decline button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400.withOpacity(0.2),
                  border: Border.all(color: Colors.red.shade400, width: 2),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                      _matchFound = false;
                    });
                    _searchTimer = Timer(
                      Duration(seconds: 2 + math.Random().nextInt(3)),
                          () {
                        if (mounted) {
                          setState(() {
                            _matchedPlayer = _mockPlayers[math.Random().nextInt(_mockPlayers.length)];
                            _matchFound = true;
                            _isSearching = false;
                          });
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.close, size: 30),
                  color: Colors.red.shade400,
                  padding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(width: 40),

              // Accept button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.greenAccent, Colors.green],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    // Navigate to match details/booking
                    context.push('/match-details', extra: _matchedPlayer);
                  },
                  icon: const Icon(Icons.check, size: 30),
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ).animate()
              .scaleXY(delay: 800.ms, duration: 400.ms)
              .fadeIn(),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white60, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRadarCircles() {
    return [1, 2, 3].map((i) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 0.8 + (_pulseController.value * 0.4);
          final opacity = 0.3 - (i * 0.1) - (_pulseController.value * 0.2);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: i * 80.0,
              height: i * 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(opacity.clamp(0, 1)),
                  width: 1,
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  String _getSportName() {
    switch (widget.sport.toLowerCase()) {
      case 'badminton':
        return 'Badminton';
      case 'football':
        return 'Football';
      case 'cricket':
        return 'Cricket';
      case 'pickleball':
        return 'Pickleball';
      default:
        return 'Sport';
    }
  }

  IconData _getSportIcon() {
    switch (widget.sport.toLowerCase()) {
      case 'badminton':
        return Icons.sports_tennis;
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'pickleball':
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }
}