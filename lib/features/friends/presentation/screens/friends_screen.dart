import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/friends_providers.dart';
import '../widgets/friend_card.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/search_users_dialog.dart';

/// Main Friends screen with tabs for friends and requests
class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsListState = ref.watch(friendsListProvider);
    final pendingRequestsState = ref.watch(pendingRequestsListProvider);

    // Count pending requests for badge
    final pendingCount = pendingRequestsState.maybeWhen(
      data: (requests) => requests.length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.primaryBlue),
            onPressed: () => _showSearchUsersDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey600,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          tabs: [
            const Tab(text: 'Friends'),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Requests'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$pendingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Friends Tab
          _buildFriendsTab(friendsListState),

          // Requests Tab
          _buildRequestsTab(pendingRequestsState),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(AsyncValue<List<dynamic>> friendsListState) {
    return friendsListState.when(
      data: (friends) {
        if (friends.isEmpty) {
          return _buildEmptyState(
            icon: Icons.people_outline,
            title: 'No Friends Yet',
            message: 'Add friends to start playing together!',
            actionLabel: 'Add Friends',
            onAction: () => _showSearchUsersDialog(context),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(friendsListProvider.notifier).refresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendCard(
                friend: friend,
                onTap: () {
                  // Navigate to friend's profile or start a match
                  _showFriendOptions(context, friend);
                },
                onRemove: () => _confirmRemoveFriend(context, friend),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(
        error.toString(),
            () => ref.read(friendsListProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildRequestsTab(AsyncValue<List<dynamic>> pendingRequestsState) {
    return pendingRequestsState.when(
      data: (requests) {
        if (requests.isEmpty) {
          return _buildEmptyState(
            icon: Icons.notifications_none,
            title: 'No Pending Requests',
            message: 'You have no friend requests at the moment.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(pendingRequestsListProvider.notifier).refresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return FriendRequestCard(
                request: request,
                onAccept: () async {
                  try {
                    await ref
                        .read(pendingRequestsListProvider.notifier)
                        .acceptRequest(request.id);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${request.friendName} is now your friend!'),
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
                },
                onReject: () async {
                  try {
                    await ref
                        .read(pendingRequestsListProvider.notifier)
                        .rejectRequest(request.id);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request rejected'),
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
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(
        error.toString(),
            () => ref.read(pendingRequestsListProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.person_add),
                label: Text(actionLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SearchUsersDialog(),
    );
  }

  void _showFriendOptions(BuildContext context, dynamic friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primaryBlue),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile view coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports, color: AppColors.primaryBlue),
              title: const Text('Challenge to Match'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to matchmaking
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Challenge feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: AppColors.primaryBlue),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to chat
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat feature coming soon!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.red),
              title: const Text('Remove Friend'),
              onTap: () {
                Navigator.pop(context);
                _confirmRemoveFriend(context, friend);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemoveFriend(BuildContext context, dynamic friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend?'),
        content: Text(
          'Are you sure you want to remove ${friend.friendName} from your friends list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                await ref
                    .read(friendsListProvider.notifier)
                    .removeFriend(friend.id);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Friend removed'),
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
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}