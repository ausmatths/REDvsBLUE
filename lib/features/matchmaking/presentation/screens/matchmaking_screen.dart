import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = [
      {'name': 'Badminton', 'icon': Icons.sports_tennis, 'color': AppColors.primaryRed},
      {'name': 'Cricket', 'icon': Icons.sports_cricket, 'color': AppColors.primaryBlue},
      {'name': 'Football', 'icon': Icons.sports_soccer, 'color': AppColors.success},
      {'name': 'Basketball', 'icon': Icons.sports_basketball, 'color': AppColors.warning},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.redLight,
              AppColors.blueLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Find Your Match',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.5, end: 0),
                    const SizedBox(height: 8),
                    const Text(
                      'Select a sport to start matchmaking',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ).animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms),
                  ],
                ),
              ),

              // Sports Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: sports.length,
                    itemBuilder: (context, index) {
                      final sport = sports[index];
                      return _SportCard(
                        sport: sport,
                        index: index,
                        onTap: () {
                          context.go('/match-search/${sport['name'].toString().toLowerCase()}');
                        },
                      );
                    },
                  ),
                ),
              ),

              // Quick Match Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.primaryBlue],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Quick match with any sport
                      context.go('/match-search/any');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'QUICK MATCH',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 1, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  final Map<String, dynamic> sport;
  final int index;
  final VoidCallback onTap;

  const _SportCard({
    required this.sport,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (sport['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sport['icon'] as IconData,
                size: 50,
                color: sport['color'] as Color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sport['name'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Find opponents',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ).animate()
          .fadeIn(delay: Duration(milliseconds: 200 + (index * 100)))
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }
}