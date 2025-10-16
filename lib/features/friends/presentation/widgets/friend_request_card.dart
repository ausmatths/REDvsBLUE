import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/friend_entity.dart';

/// Card widget to display a friend request with accept/reject actions
class FriendRequestCard extends StatelessWidget {
  final FriendEntity request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Profile Photo
                CircleAvatar(
                  radius: 28,
                  backgroundImage: request.friendPhotoUrl != null
                      ? NetworkImage(request.friendPhotoUrl!)
                      : null,
                  backgroundColor: AppColors.primaryRed.withOpacity(0.1),
                  child: request.friendPhotoUrl == null
                      ? Text(
                    request.friendName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 16),

                // Request Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.friendName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildMedalBadge(request.friendMedalLevel),
                          const SizedBox(width: 8),
                          Text(
                            '${request.friendGmrPoints} GMR',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTimeAgo(request.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (request.friendSports.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: request.friendSports.map((sport) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sport,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalBadge(String medalLevel) {
    Color medalColor;
    IconData medalIcon;

    switch (medalLevel.toLowerCase()) {
      case 'bronze':
        medalColor = const Color(0xFFCD7F32);
        medalIcon = Icons.workspace_premium;
        break;
      case 'silver':
        medalColor = const Color(0xFFC0C0C0);
        medalIcon = Icons.workspace_premium;
        break;
      case 'gold':
        medalColor = const Color(0xFFFFD700);
        medalIcon = Icons.workspace_premium;
        break;
      case 'platinum':
        medalColor = const Color(0xFFE5E4E2);
        medalIcon = Icons.star;
        break;
      case 'diamond':
        medalColor = const Color(0xFFB9F2FF);
        medalIcon = Icons.diamond;
        break;
      case 'master':
        medalColor = const Color(0xFF9C27B0);
        medalIcon = Icons.emoji_events;
        break;
      case 'grand master':
        medalColor = const Color(0xFFFF6B00);
        medalIcon = Icons.military_tech;
        break;
      default:
        medalColor = AppColors.grey400;
        medalIcon = Icons.workspace_premium;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: medalColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            medalIcon,
            size: 12,
            color: medalColor,
          ),
          const SizedBox(width: 4),
          Text(
            medalLevel,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: medalColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}