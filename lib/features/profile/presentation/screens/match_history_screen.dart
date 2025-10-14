// lib/features/profile/presentation/screens/match_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/sport_types.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/match_providers.dart';
import '../widgets/match_history_card.dart';
import '../widgets/sport_filter_chip.dart';

class MatchHistoryScreen extends ConsumerStatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  ConsumerState<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends ConsumerState<MatchHistoryScreen> {
  String _selectedSport = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get current user ID
    final userAsync = ref.watch(authStateChangesProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please log in to view match history'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildMatchHistoryContent(user.uid);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildMatchHistoryContent(String userId) {
    // Watch matches based on selected sport
    final matchesAsync = _selectedSport == 'All'
        ? ref.watch(userMatchesProvider(userId))
        : ref.watch(userMatchesBySportProvider(userId, _selectedSport));

    // Watch stats for the selected sport
    final statsAsync = _selectedSport == 'All'
        ? ref.watch(userMatchStatsProvider(userId))
        : ref.watch(userMatchStatsBySportProvider(userId, _selectedSport));

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text(
          'Match History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sport Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SportFilterChip(
                    label: 'All',
                    isSelected: _selectedSport == 'All',
                    onTap: () => setState(() => _selectedSport = 'All'),
                  ),
                  const SizedBox(width: 8),
                  ...SportTypes.allSports.map((sport) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SportFilterChip(
                        label: sport,
                        icon: SportTypes.getSportIcon(sport),
                        isSelected: _selectedSport == sport,
                        onTap: () => setState(() => _selectedSport = sport),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          const Divider(height: 1),

          // Stats Summary
          statsAsync.when(
            data: (stats) => _buildStatsSummary(stats),
            loading: () => Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => const SizedBox.shrink(),
          ),

          // Match List
          Expanded(
            child: matchesAsync.when(
              data: (matches) {
                if (matches.isEmpty) {
                  return _buildEmptyState(userId);
                }

                return RefreshIndicator(
                  onRefresh: () => _refreshMatches(userId),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return MatchHistoryCard(
                        match: match,
                        userId: userId,
                        onTap: () => _navigateToMatchDetail(match.id),
                      ).animate().fadeIn(
                        delay: (index * 50).ms,
                        duration: 300.ms,
                      ).slideX(
                        begin: 0.2,
                        end: 0,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading matches',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(userMatchesProvider(userId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(MatchStats stats) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: 'Matches',
            value: '${stats.totalMatches}',
            color: AppColors.primaryBlue,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Wins',
            value: '${stats.wins}',
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Losses',
            value: '${stats.losses}',
            color: AppColors.error,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Win Rate',
            value: '${stats.winRate.toStringAsFixed(0)}%',
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.grey400,
          ).animate().scale(duration: 500.ms),
          const SizedBox(height: 16),
          const Text(
            'No match history',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedSport == 'All'
                ? 'Play your first match to see it here!'
                : 'No $_selectedSport matches yet',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/matchmaking');
            },
            icon: const Icon(Icons.sports_tennis),
            label: const Text('Find Match'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('This Week'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('This Month'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('All Time'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: AppColors.success),
                title: const Text('Wins Only'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: AppColors.error),
                title: const Text('Losses Only'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshMatches(String userId) async {
    ref.invalidate(userMatchesProvider(userId));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToMatchDetail(String matchId) {
    context.push('/match-history/$matchId');
  }
}