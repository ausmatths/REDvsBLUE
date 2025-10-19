// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/match_detail_screen.dart';
import '../../features/profile/presentation/screens/match_history_screen.dart';
import '../../features/profile/presentation/screens/user_profile_view_screen.dart';
import '../../features/venue/presentation/screens/venue_list_screen.dart';
import '../../features/venue/presentation/screens/venue_details_screen.dart';
import '../../features/venue/presentation/screens/venue_booking_screen.dart';
import '../../features/matchmaking/presentation/screens/match_search_screen.dart';
import 'package:redvsblue/features/profile/presentation/screens/statistics_screen.dart';
import '../../features/friends/presentation/screens/friends_screen.dart';

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
          if (playerData == null) {
            return const Scaffold(
              body: Center(child: Text('No match data provided')),
            );
          }
          final matchId = playerData['matchId'] as String? ?? 'unknown';
          return MatchDetailScreen(matchId: matchId);
        },
      ),

      // Match History
      GoRoute(
        path: '/match-history',
        name: 'match-history',
        builder: (context, state) => const MatchHistoryScreen(),
      ),

      // Statistics
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),

      // Friends
      GoRoute(
        path: '/friends',
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),

      // User Profile View (for viewing other users' profiles)
      GoRoute(
        path: '/user-profile/:userId',
        name: 'user-profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          if (userId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('User ID not provided'),
              ),
            );
          }
          return UserProfileViewScreen(userId: userId);
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
          final venue = state.extra as Map<String, dynamic>?;
          if (venue == null) {
            return const Scaffold(
              body: Center(child: Text('Venue data not provided')),
            );
          }
          return VenueDetailsScreen(venue: venue);
        },
      ),
      GoRoute(
        path: '/venue-booking',
        builder: (context, state) {
          final venue = state.extra as Map<String, dynamic>?;
          if (venue == null) {
            return const Scaffold(
              body: Center(child: Text('Venue data not provided')),
            );
          }
          return VenueBookingScreen(venue: venue);
        },
      ),

      // Root route - redirect to splash
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