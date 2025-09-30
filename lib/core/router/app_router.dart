import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/matchmaking/presentation/screens/matchmaking_screen.dart';
import '../../features/venue/presentation/screens/venue_list_screen.dart';
import '../../features/venue/presentation/screens/venue_details_screen.dart';
import 'package:redvsblue/features/matchmaking/presentation/screens/match_search_screen.dart';

// GoRouter provider for Riverpod
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OTPVerificationScreen(phoneNumber: phoneNumber);
        },
      ),

      // Home Screen with Bottom Navigation
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Matchmaking Routes
      GoRoute(
        path: '/match-search/:sport',
        builder: (context, state) {
          final sport = state.pathParameters['sport'] ?? 'badminton';
          return MatchSearchScreen(sport: sport);
        },
      ),

      // Match Details
      GoRoute(
        path: '/match-details',
        builder: (context, state) {
          final playerData = state.extra as Map<String, dynamic>?;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Match Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  Text(
                    'Match with ${playerData?['name'] ?? 'Player'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Booking system coming soon!'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Venue Routes
      GoRoute(
        path: '/venues',
        builder: (context, state) => const VenueListScreen(),
      ),
      GoRoute(
        path: '/venue-details',
        builder: (context, state) {
          final venue = state.extra as Map<String, dynamic>;
          return VenueDetailsScreen(venue: venue);
        },
      ),
      GoRoute(
        path: '/venue-booking',
        builder: (context, state) {
          final venue = state.extra as Map<String, dynamic>;
          return VenueBookingScreen(venue: venue);
        },
      ),

      // Redirect default route to splash
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});