// lib/features/profile/presentation/screens/profile_test_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../../auth/presentation/providers/auth_providers_with_profile.dart';
import '../providers/user_profile_providers.dart';

/// Test screen for testing profile system functionality
///
/// Add this to your router for easy testing:
/// ```dart
/// GoRoute(
///   path: '/profile-test',
///   builder: (context, state) => const ProfileTestScreen(),
/// ),
/// ```
class ProfileTestScreen extends ConsumerWidget {
  const ProfileTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile Test')),
        body: const Center(
          child: Text('Please sign in first'),
        ),
      );
    }

    final profileState = ref.watch(userProfileProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Test Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(userProfileProvider(user.uid));
            },
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) => _buildTestContent(context, ref, user.uid, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userProfileProvider(user.uid));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestContent(
      BuildContext context,
      WidgetRef ref,
      String userId,
      UserProfileEntity profile,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('User ID', userId),
                  _buildStatRow('Name', profile.displayName),
                  _buildStatRow('Email', profile.email),
                  const Divider(height: 32),
                  _buildStatRow('GMR Points', profile.gmrPoints.toString()),
                  _buildStatRow(
                      'Medal Level', profile.medalLevel.displayName),
                  _buildStatRow(
                      'Matches Played', profile.matchesPlayed.toString()),
                  _buildStatRow('Wins', profile.wins.toString()),
                  _buildStatRow('Losses', profile.losses.toString()),
                  _buildStatRow('Draws', profile.draws.toString()),
                  _buildStatRow(
                      'Win Rate', '${profile.winRate.toStringAsFixed(1)}%'),
                  const Divider(height: 32),
                  _buildStatRow('Sports', profile.sports.join(', ')),
                  _buildStatRow(
                      'Achievements', profile.achievements.length.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Test Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simulate Win
                  ElevatedButton.icon(
                    onPressed: () => _simulateMatch(
                      context,
                      ref,
                      userId,
                      isWin: true,
                    ),
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Simulate Win (+25 GMR)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Simulate Loss
                  ElevatedButton.icon(
                    onPressed: () => _simulateMatch(
                      context,
                      ref,
                      userId,
                      isWin: false,
                    ),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('Simulate Loss (-15 GMR)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Simulate Draw
                  ElevatedButton.icon(
                    onPressed: () => _simulateMatch(
                      context,
                      ref,
                      userId,
                      isDraw: true,
                    ),
                    icon: const Icon(Icons.remove),
                    label: const Text('Simulate Draw (+5 GMR)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Achievement
                  ElevatedButton.icon(
                    onPressed: () => _addTestAchievement(context, ref, userId),
                    icon: const Icon(Icons.emoji_events),
                    label: const Text('Add Test Achievement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Add Sports
                  ElevatedButton.icon(
                    onPressed: () => _updateSports(context, ref, userId),
                    icon: const Icon(Icons.sports_tennis),
                    label: const Text('Add All Sports'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simulate 10 Wins
                  ElevatedButton.icon(
                    onPressed: () =>
                        _simulateMultipleMatches(context, ref, userId, 10),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Simulate 10 Wins (Fast)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Achievements List
          if (profile.achievements.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...profile.achievements.map(
                          (achievement) => ListTile(
                        leading: const Icon(Icons.emoji_events),
                        title: Text(achievement.title),
                        subtitle: Text(achievement.description),
                        trailing: Text(
                          achievement.earnedAt
                              .toString()
                              .split(' ')[0], // Just the date
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _simulateMatch(
      BuildContext context,
      WidgetRef ref,
      String userId, {
        bool isWin = false,
        bool isDraw = false,
      }) async {
    try {
      final outcome = isDraw
          ? MatchOutcome.draw
          : isWin
          ? MatchOutcome.win
          : MatchOutcome.loss;

      final gmrChange = isDraw
          ? 5
          : isWin
          ? 25
          : -15;

      await ref.read(userProfileControllerProvider.notifier).updateMatchStats(
        userId: userId,
        result: MatchResult(
          matchId: 'test_${DateTime.now().millisecondsSinceEpoch}',
          outcome: outcome,
          gmrPointsChange: gmrChange,
          sport: 'Badminton',
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Match simulated! ${isWin ? 'Win' : isDraw ? 'Draw' : 'Loss'} (${gmrChange > 0 ? '+' : ''}$gmrChange GMR)'),
            backgroundColor: isWin ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addTestAchievement(
      BuildContext context,
      WidgetRef ref,
      String userId,
      ) async {
    try {
      final achievement = Achievement(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Test Achievement',
        description: 'This is a test achievement',
        icon: 'star',
        earnedAt: DateTime.now(),
      );

      await ref.read(userProfileControllerProvider.notifier).addAchievement(
        userId: userId,
        achievement: achievement,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Achievement added!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateSports(
      BuildContext context,
      WidgetRef ref,
      String userId,
      ) async {
    try {
      final sports = [
        'Badminton',
        'Cricket',
        'Football',
        'Basketball',
        'Tennis',
      ];

      await ref.read(userProfileControllerProvider.notifier).updateSports(
        userId: userId,
        sports: sports,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sports updated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _simulateMultipleMatches(
      BuildContext context,
      WidgetRef ref,
      String userId,
      int count,
      ) async {
    try {
      for (int i = 0; i < count; i++) {
        await ref.read(userProfileControllerProvider.notifier).updateMatchStats(
          userId: userId,
          result: MatchResult(
            matchId: 'test_batch_${DateTime.now().millisecondsSinceEpoch}_$i',
            outcome: MatchOutcome.win,
            gmrPointsChange: 25,
            sport: 'Badminton',
          ),
        );

        // Small delay to avoid overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count matches simulated! Check your stats!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}