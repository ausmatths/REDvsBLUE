import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/friends_providers.dart';

/// Dialog for searching and adding new friends
class SearchUsersDialog extends ConsumerStatefulWidget {
  const SearchUsersDialog({super.key});

  @override
  ConsumerState<SearchUsersDialog> createState() => _SearchUsersDialogState();
}

class _SearchUsersDialogState extends ConsumerState<SearchUsersDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(userSearchResultsProvider(_searchQuery));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Add Friends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.grey100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Search Results
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildEmptySearch()
                  : searchResults.when(
                data: (users) {
                  if (users.isEmpty) {
                    return _buildNoResults();
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserTile(user);
                    },
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
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for friends',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a name or email to find users',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(dynamic user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: user.friendPhotoUrl != null
              ? NetworkImage(user.friendPhotoUrl!)
              : null,
          backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
          child: user.friendPhotoUrl == null
              ? Text(
            user.friendName[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          )
              : null,
        ),
        title: Text(
          user.friendName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.friendEmail,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildMedalBadge(user.friendMedalLevel),
                const SizedBox(width: 8),
                Text(
                  '${user.friendGmrPoints} GMR',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildAddButton(user),
      ),
    );
  }

  Widget _buildAddButton(dynamic user) {
    final controller = ref.watch(friendsControllerProvider);

    return controller.isLoading
        ? const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    )
        : IconButton(
      icon: const Icon(Icons.person_add),
      color: AppColors.primaryBlue,
      onPressed: () => _sendFriendRequest(user),
    );
  }

  Future<void> _sendFriendRequest(dynamic user) async {
    try {
      await ref
          .read(friendsControllerProvider.notifier)
          .sendFriendRequest(user.friendId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend request sent to ${user.friendName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMedalBadge(String medalLevel) {
    Color medalColor;

    switch (medalLevel.toLowerCase()) {
      case 'bronze':
        medalColor = const Color(0xFFCD7F32);
        break;
      case 'silver':
        medalColor = const Color(0xFFC0C0C0);
        break;
      case 'gold':
        medalColor = const Color(0xFFFFD700);
        break;
      case 'platinum':
        medalColor = const Color(0xFFE5E4E2);
        break;
      case 'diamond':
        medalColor = const Color(0xFFB9F2FF);
        break;
      case 'master':
        medalColor = const Color(0xFF9C27B0);
        break;
      case 'grand master':
        medalColor = const Color(0xFFFF6B00);
        break;
      default:
        medalColor = AppColors.grey400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: medalColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        medalLevel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: medalColor,
        ),
      ),
    );
  }
}