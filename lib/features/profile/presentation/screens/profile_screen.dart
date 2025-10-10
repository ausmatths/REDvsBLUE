import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/user_profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(authRepositoryProvider).signOut();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the authentication state to get current user
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // If no user is logged in, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Watch the user profile from Firestore
        final profileState = ref.watch(userProfileStreamProvider(user.uid));

        return profileState.when(
          data: (profile) {
            return _buildProfileContent(
              context,
              displayName: profile.displayName,
              email: profile.email,
              photoURL: profile.photoUrl,
              rating: profile.gmrPoints,
              level: profile.medalLevel.toString().split('.').last,
              matchesPlayed: profile.totalMatches,
              wins: profile.wins,
              losses: profile.losses,
              winRate: profile.totalMatches > 0
                  ? (profile.wins / profile.totalMatches * 100).toStringAsFixed(1)
                  : '0.0',
              sports: profile.sports,
              achievements: profile.achievements,
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error loading profile: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Refresh the profile
                      ref.invalidate(userProfileStreamProvider(user.uid));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error loading auth: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, {
        required String displayName,
        required String email,
        String? photoURL,
        required int rating,
        required String level,
        required int matchesPlayed,
        required int wins,
        required int losses,
        required String winRate,
        required List<String> sports,
        required List<Achievement> achievements,
      }) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryRed,
              AppColors.primaryBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          // Display user's photo or default avatar
                          photoURL != null && photoURL.isNotEmpty
                              ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: photoURL,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    DefaultAvatar(
                                      size: 100,
                                      name: displayName,
                                    ),
                              ),
                            ),
                          )
                              : DefaultAvatar(
                            size: 100,
                            name: displayName,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name and Level
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelColor(level),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.military_tech,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$level • $rating GMR',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            matchesPlayed.toString(),
                            'Matches',
                          ),
                          _buildStatItem(
                            wins.toString(),
                            'Wins',
                          ),
                          _buildStatItem(
                            '$winRate%',
                            'Win Rate',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content Section
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Sports Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Sports',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            sports.isEmpty
                                ? Text(
                              'No sports added yet',
                              style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 14,
                              ),
                            )
                                : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sports
                                  .map<Widget>((sport) => Chip(
                                label: Text(sport),
                                backgroundColor: AppColors
                                    .primaryBlue
                                    .withOpacity(0.1),
                                labelStyle: const TextStyle(
                                  color: AppColors.primaryBlue,
                                ),
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Achievements Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Achievements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            achievements.isEmpty
                                ? Text(
                              'No achievements yet',
                              style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 14,
                              ),
                            )
                                : Column(
                              children: achievements
                                  .take(5) // Show only last 5
                                  .map<Widget>((achievement) {
                                return Container(
                                  margin:
                                  const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey50,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.grey200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryRed
                                              .withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          _getAchievementIcon(
                                              achievement.type),
                                          color: AppColors.primaryRed,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              achievement.title,
                                              style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              achievement.description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.grey600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Menu Items
                      _buildMenuItem(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Navigate to edit profile screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit profile feature coming soon!'),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Match History',
                        onTap: () {
                          // TODO: Navigate to match history screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.bar_chart,
                        title: 'Statistics',
                        onTap: () {
                          // TODO: Navigate to statistics screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.people,
                        title: 'Friends',
                        onTap: () {
                          // TODO: Navigate to friends screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Navigate to settings screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          // TODO: Navigate to help screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {
                          // TODO: Navigate to about screen
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        color: AppColors.error,
                        onTap: _handleLogout,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? AppColors.grey600,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: color ?? Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: color ?? AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return Colors.amber;
      case 'platinum':
        return const Color(0xFFE5E4E2);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      default:
        return Colors.grey;
    }
  }

  IconData _getAchievementIcon(AchievementType type) {
    switch (type) {
      case AchievementType.firstWin:
        return Icons.emoji_events;
      case AchievementType.winStreak:
        return Icons.local_fire_department;
      case AchievementType.matchMilestone:
        return Icons.star;
      case AchievementType.rankUp:
        return Icons.trending_up;
      case AchievementType.tournament:
        return Icons.emoji_events;
      case AchievementType.special:
        return Icons.grade;
    }
  }
}