import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _vsAnimationController;

  @override
  void initState() {
    super.initState();
    _vsAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start VS animation
    _vsAnimationController.forward();

    // Simulate initialization tasks
    await Future.delayed(const Duration(seconds: 3));

    // Check authentication status (implement later with auth provider)
    final isAuthenticated = false; // Replace with actual auth check
    final hasCompletedOnboarding = false; // Check from local storage

    if (!mounted) return;

    // Navigate based on authentication status
    if (isAuthenticated) {
      context.go('/home');
    } else if (hasCompletedOnboarding) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _vsAnimationController.dispose();
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
              AppColors.primaryRed,
              AppColors.primaryBlue,
              AppColors.blueDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Animation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // RED Text
                    Text(
                      'RED',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.5, end: 0, duration: 600.ms),

                    // VS Animation
                    AnimatedBuilder(
                      animation: _vsAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.8 + (_vsAnimationController.value * 0.4),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Text(
                              'vs',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms)
                        .scale(delay: 600.ms, duration: 500.ms),

                    // BLUE Text
                    Text(
                      'BLUE',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.5, end: 0, duration: 600.ms),
                  ],
                ),

                const SizedBox(height: 20),

                // Tagline
                Text(
                  'MATCH • PLAY • COMPETE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withOpacity(0.9),
                    letterSpacing: 4,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 800.ms)
                    .slideY(begin: 0.5, end: 0, duration: 600.ms),

                const SizedBox(height: 80),

                // Loading indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white.withOpacity(0.8),
                  ),
                  strokeWidth: 3,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(delay: 1500.ms)
                    .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 1000.ms,
                ),

                const SizedBox(height: 20),

                Text(
                  'Loading your arena...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.7),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1600.ms)
                    .shimmer(
                  delay: 2000.ms,
                  duration: 2000.ms,
                  color: AppColors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}