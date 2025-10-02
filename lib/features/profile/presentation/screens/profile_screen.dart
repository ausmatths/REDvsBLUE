import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Mock user data - Replace with actual user data from provider
  final Map<String, dynamic> userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+91 98765 43210',
    'rating': 1850,
    'level': 'Gold',
    'matches_played': 156,
    'wins': 98,
    'losses': 58,
    'win_rate': 62.8,
    'sports': ['Badminton', 'Cricket', 'Football'],
    'achievements': [
      {'icon': Icons.emoji_events, 'title': 'Tournament Winner', 'date': '2024'},
      {'icon': Icons.star, 'title': '100 Matches', 'date': '2024'},
      {'icon': Icons.local_fire_department, 'title': 'Win Streak 10', 'date': '2024'},
    ],
  };

  @override
  Widget build(BuildContext context) {
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
                          DefaultAvatar(
                            size: 100,
                            name: userData['name'],
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
                        userData['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                          color: Colors.amber,
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
                              '${userData['level']} • ${userData['rating']} GMR',
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
                            userData['matches_played'].toString(),
                            'Matches',
                          ),
                          _buildStatItem(
                            userData['wins'].toString(),
                            'Wins',
                          ),
                          _buildStatItem(
                            '${userData['win_rate']}%',
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
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: userData['sports']
                                  .map<Widget>((sport) => Chip(
                                label: Text(sport),
                                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
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
                            ...userData['achievements'].map<Widget>((achievement) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.grey200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryRed.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        achievement['icon'],
                                        color: AppColors.primaryRed,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            achievement['title'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            achievement['date'],
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Menu Items
                      _buildMenuItem(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Match History',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.bar_chart,
                        title: 'Statistics',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.people,
                        title: 'Friends',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        color: AppColors.error,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Perform logout
                                    context.go('/login');
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
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
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.grey700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.grey900,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: color ?? AppColors.grey400,
      ),
      onTap: onTap,
    );
  }
}