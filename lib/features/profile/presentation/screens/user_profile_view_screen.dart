// lib/features/profile/presentation/screens/user_profile_view_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_avatar.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../providers/user_profile_providers.dart';
import '../providers/match_providers.dart';
import '../../../auth/presentation/providers/auth_providers_with_profile.dart';

/// Screen for viewing another user's profile (read-only)
/// Used when clicking "View Profile" on a friend
class UserProfileViewScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileViewScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<UserProfileViewScreen> createState() => _UserProfileViewScreenState();
}

class _UserProfileViewScreenState extends ConsumerState<UserProfileViewScreen> {
  String _selectedSport = 'All';

  @override
  Widget build(BuildContext context) {
    // Get current user first
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.uid;

    // Debug logging
    print('🔍 UserProfileViewScreen Debug:');
    print('   Current user ID: $currentUserId');
    print('   Viewing profile ID: ${widget.userId}');

    // Check if viewing own profile
    final isOwnProfile = currentUserId != null && currentUserId == widget.userId;

    if (isOwnProfile) {
      print('⚠️  WARNING: Attempting to view your own profile!');
      print('   Redirecting to Profile tab instead...');

      // Redirect to profile tab after this frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Pop back to friends screen
          context.pop();

          // Show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot view your own profile from Friends. Use the Profile tab instead.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });

      // Show loading while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    print('✅ Viewing friend\'s profile (IDs are different)');

    final profileAsync = ref.watch(userProfileProvider(widget.userId));
    final matchesAsync = _selectedSport == 'All'
        ? ref.watch(userMatchesProvider(widget.userId))
        : ref.watch(userMatchesBySportProvider(widget.userId, _selectedSport));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        data: (profile) => CustomScrollView(
          slivers: [
            // App Bar with Profile Header
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppColors.primaryBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.primaryRed,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        // Profile Photo
                        Hero(
                          tag: 'profile_${widget.userId}',
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: profile.photoUrl != null
                                  ? CachedNetworkImage(
                                imageUrl: profile.photoUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const DefaultAvatar(size: 100),
                                errorWidget: (context, url, error) =>
                                const DefaultAvatar(size: 100),
                              )
                                  : DefaultAvatar(
                                name: profile.displayName,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Display Name
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          profile.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Medal Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getMedalColor(profile.medalLevel),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getMedalEmoji(profile.medalLevel),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${profile.medalLevel.displayName} • ${profile.gmrPoints} GMR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              '${profile.matchesPlayed}',
                              'Matches',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white30,
                            ),
                            _buildStatItem(
                              '${profile.wins}',
                              'Wins',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white30,
                            ),
                            _buildStatItem(
                              '${profile.winRate.toStringAsFixed(1)}%',
                              'Win Rate',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sports Section
                    _buildSportsSection(profile.sports),
                    const SizedBox(height: 24),

                    // Achievements Section
                    _buildAchievementsSection(profile.achievements),
                    const SizedBox(height: 24),

                    // Match History Section
                    _buildMatchHistoryHeader(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Match History List
            matchesAsync.when(
              data: (matches) {
                if (matches.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildEmptyMatches(),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final match = matches[index];
                      final isWin = match.isWinForPlayer(widget.userId);
                      final isLoss = match.isLossForPlayer(widget.userId);
                      final resultText = isWin ? 'WON' : (isLoss ? 'LOST' : 'DRAW');
                      final resultColor = isWin ? Colors.green : (isLoss ? Colors.red : Colors.orange);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.grey200),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: resultColor.withOpacity(0.2),
                              child: Icon(
                                isWin
                                    ? Icons.emoji_events
                                    : Icons.close,
                                color: resultColor,
                              ),
                            ),
                            title: Text(
                              match.sport,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(match.matchDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey600,
                              ),
                            ),
                            trailing: Text(
                              resultText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: resultColor,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(
                          duration: 300.ms,
                          delay: (index * 50).ms,
                        ),
                      );
                    },
                    childCount: matches.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('Error loading matches: $error'),
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Error loading profile: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSportsSection(List<String> sports) {
    if (sports.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.grey200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No sports added yet',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sports.map((sport) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue,
                  width: 1,
                ),
              ),
              child: Text(
                sport,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildAchievementsSection(List<Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Achievements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 12),
        if (achievements.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.grey200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No achievements yet',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        else
          ...achievements.take(3).map((achievement) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.grey200),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryRed.withOpacity(0.2),
                  child: Text(
                    _getAchievementEmoji(achievement.icon),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  achievement.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms);
          }).toList(),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildMatchHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Match History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        // Sport filter can be added here if needed
      ],
    );
  }

  Widget _buildEmptyMatches() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No matches played yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Color _getMedalColor(MedalLevel medalLevel) {
    switch (medalLevel) {
      case MedalLevel.bronze:
        return const Color(0xFFCD7F32);
      case MedalLevel.silver:
        return const Color(0xFFC0C0C0);
      case MedalLevel.gold:
        return const Color(0xFFFFD700);
      case MedalLevel.platinum:
        return const Color(0xFFE5E4E2);
      case MedalLevel.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  String _getMedalEmoji(MedalLevel medalLevel) {
    switch (medalLevel) {
      case MedalLevel.bronze:
        return '🥉';
      case MedalLevel.silver:
        return '🥈';
      case MedalLevel.gold:
        return '🥇';
      case MedalLevel.platinum:
        return '💎';
      case MedalLevel.diamond:
        return '💠';
    }
  }

  String _getAchievementEmoji(String icon) {
    switch (icon.toLowerCase()) {
      case 'star':
        return '⭐';
      case 'trophy':
      case 'emoji_events':
        return '🏆';
      case 'fire':
      case 'local_fire_department':
        return '🔥';
      case 'medal':
      case 'military_tech':
        return '🎖️';
      case 'grade':
        return '⚡';
      default:
        return '⭐';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}