import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/sport_types.dart';

class MatchDetailScreen extends StatelessWidget {
  final Map<String, dynamic> match;

  const MatchDetailScreen({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final result = match['result'] as String;
    final isWin = result == 'win';
    final isLoss = result == 'loss';

    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: CustomScrollView(
        slivers: [
          // App Bar with Result
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: isWin
                ? AppColors.success
                : isLoss
                ? AppColors.error
                : AppColors.grey600,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                result.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isWin
                        ? [AppColors.success, AppColors.success.withOpacity(0.7)]
                        : isLoss
                        ? [AppColors.error, AppColors.error.withOpacity(0.7)]
                        : [AppColors.grey600, AppColors.grey500],
                  ),
                ),
                child: Center(
                  child: Icon(
                    isWin
                        ? Icons.emoji_events
                        : isLoss
                        ? Icons.close
                        : Icons.horizontal_rule,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // GMR Change Card
                _buildGMRCard(),

                // Match Info Card
                _buildMatchInfoCard(),

                // Opponent Card
                _buildOpponentCard(),

                // Venue Card
                _buildVenueCard(),

                // Score Breakdown (if available)
                if (match['scoreBreakdown'] != null) _buildScoreBreakdown(),

                // Stats Card (if available)
                if (match['stats'] != null) _buildStatsCard(),

                // Actions
                _buildActionsCard(context),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGMRCard() {
    final gmrChange = match['gmrChange'] as int;
    final isPositive = gmrChange > 0;
    final isNegative = gmrChange < 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up
                : isNegative
                ? Icons.trending_down
                : Icons.remove,
            color: isPositive
                ? AppColors.success
                : isNegative
                ? AppColors.error
                : AppColors.grey600,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GMR Change',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isPositive ? '+' : ''}$gmrChange',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isPositive
                      ? AppColors.success
                      : isNegative
                      ? AppColors.error
                      : AppColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildMatchInfoCard() {
    final date = match['date'] as DateTime;
    final sport = match['sport'] as String;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SportTypes.getSportIcon(sport),
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Match Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.sports,
            label: 'Sport',
            value: sport,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.emoji_events,
            label: 'Match Type',
            value: match['matchType'] ?? 'Casual',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy • h:mm a').format(date),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.scoreboard,
            label: 'Score',
            value: match['score'] ?? 'N/A',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildOpponentCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryRed,
            backgroundImage: match['opponentPhoto'] != null
                ? NetworkImage(match['opponentPhoto'])
                : null,
            child: match['opponentPhoto'] == null
                ? Text(
              match['opponentName'][0].toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Opponent',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  match['opponentName'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to opponent profile
            },
            icon: const Icon(Icons.arrow_forward_ios),
            color: AppColors.grey600,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildVenueCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Venue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            match['venue'] ?? 'Unknown Venue',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Open map
            },
            icon: const Icon(Icons.map),
            label: const Text('View on Map'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildScoreBreakdown() {
    // TODO: Implement score breakdown for different sports
    return const SizedBox.shrink();
  }

  Widget _buildStatsCard() {
    // TODO: Implement stats card with match statistics
    return const SizedBox.shrink();
  }

  Widget _buildActionsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement rematch
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rematch request sent!'),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Request Rematch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Share match
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Report issue
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('Report'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.grey600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}