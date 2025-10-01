import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for 3 seconds to show the animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Go to the main route. The AuthWidget will handle the rest.
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    // Your beautiful animation code is perfect, no changes needed here.
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('RED', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.white))
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.5, end: 0, duration: 600.ms),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text('vs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.grey900)),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms)
                        .scale(delay: 600.ms, duration: 500.ms),
                    const Text('BLUE', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.white))
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.5, end: 0, duration: 600.ms),
                  ],
                ),
                const SizedBox(height: 80),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}