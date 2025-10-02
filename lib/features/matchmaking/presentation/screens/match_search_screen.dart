import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class MatchSearchScreen extends StatefulWidget {
  final String sport;

  const MatchSearchScreen({
    super.key,
    required this.sport,
  });

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreenState();
}

class _MatchSearchScreenState extends State<MatchSearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _fireController;
  late AnimationController _waterController;
  late AnimationController _pulseController;
  bool _matchFound = false;

  @override
  void initState() {
    super.initState();
    _fireController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _waterController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Simulate finding a match after 5 seconds
    _findMatch();
  }

  Future<void> _findMatch() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        _matchFound = true;
      });

      // Navigate to match details after showing match found animation
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/match-details', extra: {
          'name': 'John Doe',
          'rating': 1500,
          'sport': widget.sport,
        });
      }
    }
  }

  @override
  void dispose() {
    _fireController.dispose();
    _waterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.redDark,
              AppColors.grey900,
              AppColors.blueDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.go('/home'),
                    ),
                    Expanded(
                      child: Text(
                        'Finding ${widget.sport.toUpperCase()} Match',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Main Animation Area
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Fire vs Water Animation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Fire Side (Red Team)
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Fire animation
                                AnimatedBuilder(
                                  animation: _fireController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        -10 * _fireController.value,
                                      ),
                                      child: Container(
                                        width: 120,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.yellow.withOpacity(0.8),
                                              Colors.orange.withOpacity(0.6),
                                              AppColors.primaryRed.withOpacity(0.4),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.local_fire_department,
                                          size: 80,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // RED text
                                const Positioned(
                                  bottom: 50,
                                  child: Text(
                                    'RED',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryRed,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 20,
                                          color: AppColors.primaryRed,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: -1, end: 0),

                          // VS in the middle
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.2),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'VS',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Water Side (Blue Team)
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Water animation
                                AnimatedBuilder(
                                  animation: _waterController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        10 * (0.5 - (_waterController.value - 0.5).abs()),
                                      ),
                                      child: Container(
                                        width: 120,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.lightBlueAccent.withOpacity(0.8),
                                              Colors.blue.withOpacity(0.6),
                                              AppColors.primaryBlue.withOpacity(0.4),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.water_drop,
                                          size: 80,
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // BLUE text
                                const Positioned(
                                  bottom: 50,
                                  child: Text(
                                    'BLUE',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryBlue,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 20,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate()
                              .fadeIn(duration: 1000.ms)
                              .slideX(begin: 1, end: 0),
                        ],
                      ),

                      // Match Found Overlay
                      if (_matchFound)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 100,
                                  color: Colors.green,
                                ).animate()
                                    .scale(duration: 500.ms)
                                    .fadeIn(),
                                const SizedBox(height: 20),
                                const Text(
                                  'MATCH FOUND!',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ).animate()
                                    .fadeIn(delay: 300.ms)
                                    .slideY(begin: 0.5, end: 0),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 500.ms),
                    ],
                  ),
                ),
              ),

              // Search Status
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (!_matchFound) ...[
                      const LinearProgressIndicator(
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Searching for opponents...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sport: ${widget.sport.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Cancel Button
                    if (!_matchFound)
                      TextButton(
                        onPressed: () => context.go('/home'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.white24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Cancel Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}