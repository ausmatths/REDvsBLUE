import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/sport_types.dart';
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

  // Mock data - Replace with actual Riverpod provider later
  final List<Map<String, dynamic>> _mockMatches = [
    {
      'id': '1',
      'sport': 'Badminton',
      'opponentName': 'Rahul Sharma',
      'opponentPhoto': null,
      'result': 'win',
      'score': '21-18, 21-15',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'venue': 'SportZone Arena',
      'gmrChange': 25,
      'matchType': 'Ranked',
    },
    {
      'id': '2',
      'sport': 'Football',
      'opponentName': 'Blue Dragons',
      'opponentPhoto': null,
      'result': 'loss',
      'score': '2-3',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'venue': 'City Sports Complex',
      'gmrChange': -15,
      'matchType': 'Tournament',
    },
    {
      'id': '3',
      'sport': 'Badminton',
      'opponentName': 'Priya Patel',
      'opponentPhoto': null,
      'result': 'win',
      'score': '21-12, 19-21, 21-16',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'venue': 'Elite Badminton Center',
      'gmrChange': 30,
      'matchType': 'Casual',
    },
    {
      'id': '4',
      'sport': 'Cricket',
      'opponentName': 'Red Warriors',
      'opponentPhoto': null,
      'result': 'win',
      'score': '185/7 vs 180/9',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'venue': 'Grand Cricket Stadium',
      'gmrChange': 28,
      'matchType': 'Ranked',
    },
    {
      'id': '5',
      'sport': 'Badminton',
      'opponentName': 'Amit Kumar',
      'opponentPhoto': null,
      'result': 'draw',
      'score': '21-19, 18-21',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'venue': 'SportZone Arena',
      'gmrChange': 0,
      'matchType': 'Casual',
    },
  ];

  List<Map<String, dynamic>> get _filteredMatches {
    if (_selectedSport == 'All') {
      return _mockMatches;
    }
    return _mockMatches.where((match) => match['sport'] == _selectedSport).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _buildStatsSummary(),

          // Match List
          Expanded(
            child: _filteredMatches.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _refreshMatches,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _filteredMatches.length,
                itemBuilder: (context, index) {
                  final match = _filteredMatches[index];
                  return MatchHistoryCard(
                    match: match,
                    onTap: () => _navigateToMatchDetail(match),
                  ).animate().fadeIn(
                    delay: (index * 50).ms,
                    duration: 300.ms,
                  ).slideX(
                    begin: 0.2,
                    end: 0,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    // Calculate stats from filtered matches
    final wins = _filteredMatches.where((m) => m['result'] == 'win').length;
    final losses = _filteredMatches.where((m) => m['result'] == 'loss').length;
    final winRate = _filteredMatches.isEmpty
        ? 0.0
        : (wins / _filteredMatches.length * 100);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: 'Matches',
            value: '${_filteredMatches.length}',
            color: AppColors.primaryBlue,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Wins',
            value: '$wins',
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Losses',
            value: '$losses',
            color: AppColors.error,
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          _buildStatItem(
            label: 'Win Rate',
            value: '${winRate.toStringAsFixed(0)}%',
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

  Widget _buildEmptyState() {
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

  Future<void> _refreshMatches() async {
    // TODO: Implement refresh logic with actual provider
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match history refreshed!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _navigateToMatchDetail(Map<String, dynamic> match) {
    context.push('/match-history/${match['id']}', extra: match);
  }
}