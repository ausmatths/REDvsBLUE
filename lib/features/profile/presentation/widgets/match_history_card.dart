import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/sport_types.dart';

class MatchHistoryCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final VoidCallback onTap;

  const MatchHistoryCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final result = match['result'] as String;
    final isWin = result == 'win';
    final isLoss = result == 'loss';
    final sport = match['sport'] as String;
    final date = match['date'] as DateTime;
    final gmrChange = match['gmrChange'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: isWin
                    ? AppColors.success
                    : isLoss
                    ? AppColors.error
                    : AppColors.grey400,
                width: 4,
              ),
            ),
          ),
          child: Column(
            children: [
              // Header Row: Sport Icon, Name, Result Badge
              Row(
                children: [
                  // Sport Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.blueBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      SportTypes.getSportIcon(sport),
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sport Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sport,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          match['matchType'] ?? 'Casual',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Result Badge
                  _buildResultBadge(result),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Opponent Row
              Row(
                children: [
                  // Opponent Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryRed.withOpacity(0.2),
                    backgroundImage: match['opponentPhoto'] != null
                        ? NetworkImage(match['opponentPhoto'])
                        : null,
                    child: match['opponentPhoto'] == null
                        ? Text(
                      match['opponentName'][0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Opponent Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match['opponentName'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          match['venue'] ?? 'Unknown Venue',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bottom Row: Score, Date, GMR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.scoreboard,
                      label: match['score'] ?? 'N/A',
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Date
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: _formatDate(date),
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // GMR Change
                  _buildGMRChip(gmrChange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBadge(String result) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (result) {
      case 'win':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        icon = Icons.emoji_events;
        text = 'WIN';
        break;
      case 'loss':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        icon = Icons.close;
        text = 'LOSS';
        break;
      case 'draw':
        backgroundColor = AppColors.grey300;
        textColor = AppColors.grey700;
        icon = Icons.horizontal_rule;
        text = 'DRAW';
        break;
      default:
        backgroundColor = AppColors.grey300;
        textColor = AppColors.grey700;
        icon = Icons.help_outline;
        text = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGMRChip(int gmrChange) {
    final isPositive = gmrChange > 0;
    final isNegative = gmrChange < 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.success.withOpacity(0.1)
            : isNegative
            ? AppColors.error.withOpacity(0.1)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPositive
              ? AppColors.success
              : isNegative
              ? AppColors.error
              : AppColors.grey400,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward
                : isNegative
                ? Icons.arrow_downward
                : Icons.remove,
            size: 14,
            color: isPositive
                ? AppColors.success
                : isNegative
                ? AppColors.error
                : AppColors.grey600,
          ),
          const SizedBox(width: 4),
          Text(
            '${gmrChange.abs()}',
            style: TextStyle(
              fontSize: 12,
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
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }
}