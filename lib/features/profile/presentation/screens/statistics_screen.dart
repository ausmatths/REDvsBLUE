import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/sport_types.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/match_providers.dart';
import '../providers/user_profile_providers.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/user_profile_entity.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSport = 'All';
  String _selectedPeriod = 'All Time';

  final List<String> _periods = ['All Time', 'This Month', 'Last 30 Days', 'Last 7 Days'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please log in to view statistics')),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text(
              'Statistics',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showPeriodFilter,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2196F3),
              unselectedLabelColor: const Color(0xFF9E9E9E),
              indicatorColor: const Color(0xFF2196F3),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Performance'),
                Tab(text: 'Progress'),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildSportFilter(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(user.uid),
                    _buildPerformanceTab(user.uid),
                    _buildProgressTab(user.uid),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSportFilter() {
    final sports = ['All', ...SportTypes.allSports];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sports.map((sport) {
            final isSelected = _selectedSport == sport;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(sport),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedSport = sport;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildOverviewTab(String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallStatsCard(userId),
          const SizedBox(height: 16),
          _buildSportBreakdown(userId),
          const SizedBox(height: 16),
          _buildRecentPerformance(userId),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceMetrics(userId),
          const SizedBox(height: 16),
          _buildMatchOutcomeChart(userId),
          const SizedBox(height: 16),
          _buildBestWorstSports(userId),
        ],
      ),
    );
  }

  Widget _buildProgressTab(String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGMRProgress(userId),
          const SizedBox(height: 16),
          _buildMatchTimeline(userId),
          const SizedBox(height: 16),
          _buildAchievementsSection(userId),
        ],
      ),
    );
  }

  // ============================================================================
  // OVERVIEW TAB WIDGETS WITH REAL DATA
  // ============================================================================

  Widget _buildOverallStatsCard(String userId) {
    final statsAsync = _selectedSport == 'All'
        ? ref.watch(userMatchStatsProvider(userId))
        : ref.watch(userMatchStatsBySportProvider(userId, _selectedSport));

    final profileAsync = ref.watch(userProfileProvider(userId));

    return statsAsync.when(
      data: (stats) => profileAsync.when(
        data: (profile) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'Matches',
                      '${stats.totalMatches}',
                      Icons.sports_tennis,
                      const Color(0xFF2196F3),
                    ),
                    _buildStatColumn(
                      'Wins',
                      '${stats.wins}',
                      Icons.emoji_events,
                      const Color(0xFF4CAF50),
                    ),
                    _buildStatColumn(
                      'Win Rate',
                      '${stats.winRate.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      const Color(0xFFFF9800),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'Losses',
                      '${stats.losses}',
                      Icons.close,
                      const Color(0xFFF44336),
                    ),
                    _buildStatColumn(
                      'Draws',
                      '${stats.draws}',
                      Icons.horizontal_rule,
                      const Color(0xFF9E9E9E),
                    ),
                    _buildStatColumn(
                      'GMR',
                      '${profile.gmrPoints}',
                      Icons.star,
                      const Color(0xFFFFD700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
        loading: () => const Card(
          child: Padding(
            padding: EdgeInsets.all(60),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (e, s) => Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Error loading profile: $e'),
          ),
        ),
      ),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading stats: $e'),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
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
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildSportBreakdown(String userId) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance by Sport',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...SportTypes.allSports.map((sport) {
              return _buildSportBreakdownItem(userId, sport);
            }),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildSportBreakdownItem(String userId, String sport) {
    final statsAsync = ref.watch(userMatchStatsBySportProvider(userId, sport));

    return statsAsync.when(
      data: (stats) {
        if (stats.totalMatches == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sport,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${stats.wins}/${stats.totalMatches} (${stats.winRate.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: SportTypes.getSportColor(sport),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: stats.winRate / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    SportTypes.getSportColor(sport),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentPerformance(String userId) {
    final matchesAsync = ref.watch(userMatchesProvider(userId));

    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return const SizedBox.shrink();
        }

        // Get last 5 matches
        final recentMatches = matches.take(5).toList();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Form',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: recentMatches.map((match) {
                    final opponentInfo = match.getOpponentInfo(userId);
                    Color color;
                    String label;

                    switch (opponentInfo.outcome) {
                      case MatchOutcome.win:
                        color = const Color(0xFF4CAF50);
                        label = 'W';
                        break;
                      case MatchOutcome.loss:
                        color = const Color(0xFFF44336);
                        label = 'L';
                        break;
                      case MatchOutcome.draw:
                        color = const Color(0xFF9E9E9E);
                        label = 'D';
                        break;
                    }

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  // ============================================================================
  // PERFORMANCE TAB WIDGETS WITH REAL DATA
  // ============================================================================

  Widget _buildPerformanceMetrics(String userId) {
    final matchesAsync = ref.watch(userMatchesProvider(userId));

    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return _buildEmptyStateCard('No matches played yet');
        }

        // Calculate metrics
        final sportCounts = <String, int>{};
        for (final match in matches) {
          sportCounts[match.sport] = (sportCounts[match.sport] ?? 0) + 1;
        }

        final mostPlayedSport = sportCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        // Calculate win streaks
        int currentStreak = 0;
        int longestStreak = 0;

        for (final match in matches) {
          final opponentInfo = match.getOpponentInfo(userId);
          if (opponentInfo.outcome == MatchOutcome.win) {
            currentStreak++;
            if (currentStreak > longestStreak) {
              longestStreak = currentStreak;
            }
          } else {
            currentStreak = 0;
          }
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildMetricRow(
                  'Total Matches',
                  '${matches.length}',
                  Icons.sports_tennis,
                ),
                const SizedBox(height: 12),
                _buildMetricRow(
                  'Longest Win Streak',
                  '$longestStreak matches',
                  Icons.local_fire_department,
                ),
                const SizedBox(height: 12),
                _buildMetricRow(
                  'Most Played Sport',
                  mostPlayedSport,
                  Icons.sports,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading metrics: $e'),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2196F3), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchOutcomeChart(String userId) {
    final statsAsync = _selectedSport == 'All'
        ? ref.watch(userMatchStatsProvider(userId))
        : ref.watch(userMatchStatsBySportProvider(userId, _selectedSport));

    return statsAsync.when(
      data: (stats) {
        if (stats.totalMatches == 0) {
          return _buildEmptyStateCard('No matches to display');
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Match Outcomes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: [
                              PieChartSectionData(
                                value: stats.wins.toDouble(),
                                title: 'Wins\n${stats.winRate.toStringAsFixed(0)}%',
                                color: const Color(0xFF4CAF50),
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: stats.losses.toDouble(),
                                title: 'Losses\n${((stats.losses / stats.totalMatches) * 100).toStringAsFixed(0)}%',
                                color: const Color(0xFFF44336),
                                radius: 70,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (stats.draws > 0)
                                PieChartSectionData(
                                  value: stats.draws.toDouble(),
                                  title: 'Draws\n${((stats.draws / stats.totalMatches) * 100).toStringAsFixed(0)}%',
                                  color: const Color(0xFF9E9E9E),
                                  radius: 70,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading chart: $e'),
        ),
      ),
    );
  }

  Widget _buildBestWorstSports(String userId) {
    // Calculate best and worst performing sports
    final sportStats = <String, MatchStats>{};

    for (final sport in SportTypes.allSports) {
      final statsAsync = ref.watch(userMatchStatsBySportProvider(userId, sport));
      statsAsync.whenData((stats) {
        if (stats.totalMatches > 0) {
          sportStats[sport] = stats;
        }
      });
    }

    if (sportStats.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedSports = sportStats.entries.toList()
      ..sort((a, b) => b.value.winRate.compareTo(a.value.winRate));

    final bestSport = sortedSports.first;
    final worstSport = sortedSports.length > 1 ? sortedSports.last : null;

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFF4CAF50), size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Best Sport',
                    style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bestSport.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${bestSport.value.winRate.toStringAsFixed(0)}% Win Rate',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (worstSport != null)
          Expanded(
            child: Card(
              elevation: 2,
              color: const Color(0xFFFF9800).withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.trending_down, color: Color(0xFFFF9800), size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Needs Work',
                      style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      worstSport.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${worstSport.value.winRate.toStringAsFixed(0)}% Win Rate',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  // ============================================================================
  // PROGRESS TAB WIDGETS WITH REAL DATA
  // ============================================================================

  Widget _buildGMRProgress(String userId) {
    final profileAsync = ref.watch(userProfileProvider(userId));

    return profileAsync.when(
      data: (profile) {
        final currentLevel = profile.medalLevel;
        final nextLevel = MedalLevel.values.firstWhere(
              (level) => level.minPoints > profile.gmrPoints,
          orElse: () => MedalLevel.diamond, // Already at max
        );

        final pointsToNext = nextLevel == MedalLevel.diamond &&
            profile.gmrPoints >= MedalLevel.diamond.minPoints
            ? 0
            : nextLevel.minPoints - profile.gmrPoints;

        final progress = currentLevel == MedalLevel.diamond &&
            profile.gmrPoints >= MedalLevel.diamond.minPoints
            ? 1.0
            : (profile.gmrPoints - currentLevel.minPoints) /
            (nextLevel.minPoints - currentLevel.minPoints);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GMR Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current GMR',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFD700), size: 32),
                            const SizedBox(width: 8),
                            Text(
                              '${profile.gmrPoints}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getMedalColor(currentLevel),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            currentLevel.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (pointsToNext > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Next: ${nextLevel.displayName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$pointsToNext GMR',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'to reach',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      )
                    else
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 32),
                          SizedBox(height: 4),
                          Text(
                            'Max Level!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pointsToNext > 0
                      ? '${(progress * 100).toStringAsFixed(0)}% to next level'
                      : 'Maximum level achieved!',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading GMR: $e'),
        ),
      ),
    );
  }

  Color _getMedalColor(MedalLevel level) {
    switch (level) {
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

  Widget _buildMatchTimeline(String userId) {
    final matchesAsync = ref.watch(userMatchesProvider(userId));

    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return _buildEmptyStateCard('No match history yet');
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Match History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to full match history
                        // context.push('/match-history');
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Matches: ${matches.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading timeline: $e'),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(String userId) {
    final profileAsync = ref.watch(userProfileProvider(userId));

    return profileAsync.when(
      data: (profile) {
        if (profile.achievements.isEmpty) {
          return _buildEmptyStateCard('No achievements yet');
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements (${profile.achievements.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: profile.achievements.map((achievement) {
                    return Container(
                      width: (MediaQuery.of(context).size.width - 76) / 2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            size: 32,
                            color: Color(0xFFFFD700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading achievements: $e'),
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(String message) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPeriodFilter() {
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
                'Select Time Period',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._periods.map((period) {
                final isSelected = _selectedPeriod == period;
                return ListTile(
                  title: Text(period),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF2196F3))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedPeriod = period;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}