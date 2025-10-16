import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/friends_remote_data_source.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/friends_repository.dart';
import '../../domain/usecases/friends_usecases.dart';
import '../../../auth/presentation/providers/auth_providers_with_profile.dart';

part 'friends_providers.g.dart';

// Data Source Provider
@riverpod
FriendsRemoteDataSource friendsRemoteDataSource(
    FriendsRemoteDataSourceRef ref,
    ) {
  return FriendsRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
}

// Repository Provider
@riverpod
FriendsRepository friendsRepository(FriendsRepositoryRef ref) {
  return FriendsRepositoryImpl(
    remoteDataSource: ref.watch(friendsRemoteDataSourceProvider),
  );
}

// Use Case Providers
@riverpod
GetFriends getFriends(GetFriendsRef ref) {
  return GetFriends(ref.watch(friendsRepositoryProvider));
}

@riverpod
GetPendingRequests getPendingRequests(GetPendingRequestsRef ref) {
  return GetPendingRequests(ref.watch(friendsRepositoryProvider));
}

@riverpod
SendFriendRequest sendFriendRequest(SendFriendRequestRef ref) {
  return SendFriendRequest(ref.watch(friendsRepositoryProvider));
}

@riverpod
AcceptFriendRequest acceptFriendRequest(AcceptFriendRequestRef ref) {
  return AcceptFriendRequest(ref.watch(friendsRepositoryProvider));
}

@riverpod
RejectFriendRequest rejectFriendRequest(RejectFriendRequestRef ref) {
  return RejectFriendRequest(ref.watch(friendsRepositoryProvider));
}

@riverpod
RemoveFriend removeFriend(RemoveFriendRef ref) {
  return RemoveFriend(ref.watch(friendsRepositoryProvider));
}

@riverpod
BlockUser blockUser(BlockUserRef ref) {
  return BlockUser(ref.watch(friendsRepositoryProvider));
}

@riverpod
SearchUsers searchUsers(SearchUsersRef ref) {
  return SearchUsers(ref.watch(friendsRepositoryProvider));
}

@riverpod
WatchFriends watchFriends(WatchFriendsRef ref) {
  return WatchFriends(ref.watch(friendsRepositoryProvider));
}

// State Providers

/// Provider for user's friends list
@riverpod
class FriendsList extends _$FriendsList {
  @override
  Future<List<FriendEntity>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    return await _fetchFriends(user.uid);
  }

  Future<List<FriendEntity>> _fetchFriends(String userId) async {
    final getFriendsUseCase = ref.read(getFriendsProvider);
    final result = await getFriendsUseCase(userId);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (friends) => friends,
    );
  }

  Future<void> refresh() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFriends(user.uid));
  }

  Future<void> removeFriend(String friendshipId) async {
    final removeUseCase = ref.read(removeFriendProvider);
    final result = await removeUseCase(friendshipId);

    result.fold(
          (failure) => throw Exception(failure.message),
          (_) => refresh(),
    );
  }
}

/// Provider for pending friend requests
@riverpod
class PendingRequestsList extends _$PendingRequestsList {
  @override
  Future<List<FriendEntity>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    return await _fetchRequests(user.uid);
  }

  Future<List<FriendEntity>> _fetchRequests(String userId) async {
    final getPendingUseCase = ref.read(getPendingRequestsProvider);
    final result = await getPendingUseCase(userId);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (requests) => requests,
    );
  }

  Future<void> refresh() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRequests(user.uid));
  }

  Future<void> acceptRequest(String requestId) async {
    final acceptUseCase = ref.read(acceptFriendRequestProvider);
    final result = await acceptUseCase(requestId);

    result.fold(
          (failure) => throw Exception(failure.message),
          (_) {
        refresh();
        ref.read(friendsListProvider.notifier).refresh();
      },
    );
  }

  Future<void> rejectRequest(String requestId) async {
    final rejectUseCase = ref.read(rejectFriendRequestProvider);
    final result = await rejectUseCase(requestId);

    result.fold(
          (failure) => throw Exception(failure.message),
          (_) => refresh(),
    );
  }
}

/// Provider for searching users
@riverpod
class UserSearchResults extends _$UserSearchResults {
  @override
  Future<List<FriendEntity>> build(String query) async {
    if (query.isEmpty) return [];

    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final searchUseCase = ref.read(searchUsersProvider);
    final result = await searchUseCase(
      query: query,
      currentUserId: user.uid,
    );

    return result.fold(
          (failure) => throw Exception(failure.message),
          (users) => users,
    );
  }
}

/// Controller for friend operations
@riverpod
class FriendsController extends _$FriendsController {
  @override
  FutureOr<void> build() {}

  Future<void> sendFriendRequest(String friendId) async {
    state = const AsyncValue.loading();

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not logged in'),
        StackTrace.current,
      );
      return;
    }

    final sendUseCase = ref.read(sendFriendRequestProvider);
    final result = await sendUseCase(
      userId: user.uid,
      friendId: friendId,
    );

    state = result.fold(
          (failure) => AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
          (_) => const AsyncValue.data(null),
    );
  }

  Future<void> blockUser(String userId) async {
    state = const AsyncValue.loading();

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not logged in'),
        StackTrace.current,
      );
      return;
    }

    final blockUseCase = ref.read(blockUserProvider);
    final result = await blockUseCase(
      userId: user.uid,
      blockedUserId: userId,
    );

    state = result.fold(
          (failure) => AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
          (_) {
        ref.read(friendsListProvider.notifier).refresh();
        return const AsyncValue.data(null);
      },
    );
  }
}