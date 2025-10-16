import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/friend_entity.dart';

/// Card widget to display a friend's information
class FriendCard extends StatelessWidget {
  final FriendEntity friend;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FriendCard({
    super.key,
    required this.friend,
    required this.onTap,
    required this.onRemove,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 28,
                backgroundImage: friend.friendPhotoUrl != null
                    ? NetworkImage(friend.friendPhotoUrl!)
                    : null,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: friend.friendPhotoUrl == null
                    ? Text(
                  friend.friendName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 16),

              // Friend Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.friendName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildMedalBadge(friend.friendMedalLevel),
                        const SizedBox(width: 8),
                        Text(
                          '${friend.friendGmrPoints} GMR',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                    if (friend.friendSports.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: friend.friendSports.take(3).map((sport) {
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
                  ],
                ),
              ),

              // More Options Button
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.grey600,
                ),
                onPressed: onTap,
              ),
            ],
          ),
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
}