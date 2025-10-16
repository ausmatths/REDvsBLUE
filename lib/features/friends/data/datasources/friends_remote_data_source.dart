import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/friend_model.dart';

/// Remote data source for Friends using Firebase Firestore
abstract class FriendsRemoteDataSource {
  Future<List<FriendModel>> getFriends(String userId);
  Future<List<FriendModel>> getPendingRequests(String userId);
  Future<FriendModel> sendFriendRequest({
    required String userId,
    required String friendId,
  });
  Future<FriendModel> acceptFriendRequest(String requestId);
  Future<void> rejectFriendRequest(String requestId);
  Future<void> removeFriend(String friendshipId);
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  });
  Future<List<FriendModel>> searchUsers({
    required String query,
    required String currentUserId,
  });
  Stream<List<FriendModel>> watchFriends(String userId);
}

class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final FirebaseFirestore firestore;

  FriendsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FriendModel>> getFriends(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      final friends = <FriendModel>[];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final friendId = data['friendId'] as String;

        // Fetch friend's profile to get updated data
        final friendProfile = await firestore
            .collection('users')
            .doc(friendId)
            .get();

        if (friendProfile.exists) {
          final friendData = friendProfile.data()!;
          final friendModel = FriendModel.fromFirestore({
            ...data,
            'friendName': friendData['displayName'] ?? 'Unknown',
            'friendEmail': friendData['email'] ?? '',
            'friendPhotoUrl': friendData['photoUrl'],
            'friendGmrPoints': friendData['gmrPoints'] ?? 0,
            'friendMedalLevel': friendData['medalLevel'] ?? 'Bronze',
            'friendSports': friendData['sports'] ?? [],
          }, doc.id);

          friends.add(friendModel);
        }
      }

      return friends;
    } catch (e) {
      throw ServerException(message: 'Failed to load friends: ${e.toString()}');
    }
  }

  @override
  Future<List<FriendModel>> getPendingRequests(String userId) async {
    try {
      // Get requests where current user is the friendId (received requests)
      final querySnapshot = await firestore
          .collection('friendships')
          .where('friendId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      final requests = <FriendModel>[];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final requesterId = data['userId'] as String;

        // Fetch requester's profile
        final requesterProfile = await firestore
            .collection('users')
            .doc(requesterId)
            .get();

        if (requesterProfile.exists) {
          final requesterData = requesterProfile.data()!;
          final requestModel = FriendModel.fromFirestore({
            ...data,
            'friendName': requesterData['displayName'] ?? 'Unknown',
            'friendEmail': requesterData['email'] ?? '',
            'friendPhotoUrl': requesterData['photoUrl'],
            'friendGmrPoints': requesterData['gmrPoints'] ?? 0,
            'friendMedalLevel': requesterData['medalLevel'] ?? 'Bronze',
            'friendSports': requesterData['sports'] ?? [],
          }, doc.id);

          requests.add(requestModel);
        }
      }

      return requests;
    } catch (e) {
      throw ServerException(message: 'Failed to load pending requests: ${e.toString()}');
    }
  }

  @override
  Future<FriendModel> sendFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
      // Check if friendship already exists
      final existing = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: userId)
          .where('friendId', isEqualTo: friendId)
          .get();

      if (existing.docs.isNotEmpty) {
        throw ValidationException(message: 'Friend request already exists');
      }

      // Get friend's profile data
      final friendProfile = await firestore
          .collection('users')
          .doc(friendId)
          .get();

      if (!friendProfile.exists) {
        throw NotFoundExceptionCustom(message: 'User not found');
      }

      final friendData = friendProfile.data()!;

      final friendRequest = FriendModel(
        id: '', // Will be set by Firestore
        userId: userId,
        friendId: friendId,
        friendName: friendData['displayName'] ?? 'Unknown',
        friendPhotoUrl: friendData['photoUrl'],
        friendEmail: friendData['email'] ?? '',
        status: 'pending',
        createdAt: DateTime.now(),
        friendGmrPoints: friendData['gmrPoints'] ?? 0,
        friendMedalLevel: friendData['medalLevel'] ?? 'Bronze',
        friendSports: List<String>.from(friendData['sports'] ?? []),
      );

      final docRef = await firestore
          .collection('friendships')
          .add(friendRequest.toFirestore());

      return friendRequest.copyWith(id: docRef.id);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to send friend request: ${e.toString()}');
    }
  }

  @override
  Future<FriendModel> acceptFriendRequest(String requestId) async {
    try {
      await firestore
          .collection('friendships')
          .doc(requestId)
          .update({
        'status': 'accepted',
        'acceptedAt': DateTime.now().toIso8601String(),
      });

      final doc = await firestore
          .collection('friendships')
          .doc(requestId)
          .get();

      if (!doc.exists) {
        throw NotFoundExceptionCustom(message: 'Friend request not found');
      }

      return FriendModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException(message: 'Failed to accept friend request: ${e.toString()}');
    }
  }

  @override
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await firestore
          .collection('friendships')
          .doc(requestId)
          .delete();
    } catch (e) {
      throw ServerException(message: 'Failed to reject friend request: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFriend(String friendshipId) async {
    try {
      await firestore
          .collection('friendships')
          .doc(friendshipId)
          .delete();
    } catch (e) {
      throw ServerException(message: 'Failed to remove friend: ${e.toString()}');
    }
  }

  @override
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      // Remove any existing friendship
      final friendships = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: userId)
          .where('friendId', isEqualTo: blockedUserId)
          .get();

      for (var doc in friendships.docs) {
        await doc.reference.delete();
      }

      // Add to blocked users list
      await firestore
          .collection('users')
          .doc(userId)
          .update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
    } catch (e) {
      throw ServerException(message: 'Failed to block user: ${e.toString()}');
    }
  }

  @override
  Future<List<FriendModel>> searchUsers({
    required String query,
    required String currentUserId,
  }) async {
    try {
      final queryLower = query.toLowerCase();

      final querySnapshot = await firestore
          .collection('users')
          .get();

      final results = <FriendModel>[];

      for (var doc in querySnapshot.docs) {
        if (doc.id == currentUserId) continue;

        final data = doc.data();
        final displayName = (data['displayName'] as String? ?? '').toLowerCase();
        final email = (data['email'] as String? ?? '').toLowerCase();

        if (displayName.contains(queryLower) || email.contains(queryLower)) {
          results.add(FriendModel(
            id: doc.id,
            userId: currentUserId,
            friendId: doc.id,
            friendName: data['displayName'] ?? 'Unknown',
            friendPhotoUrl: data['photoUrl'],
            friendEmail: data['email'] ?? '',
            status: 'pending', // Will be checked against existing friendships
            createdAt: DateTime.now(),
            friendGmrPoints: data['gmrPoints'] ?? 0,
            friendMedalLevel: data['medalLevel'] ?? 'Bronze',
            friendSports: List<String>.from(data['sports'] ?? []),
          ));
        }
      }

      return results;
    } catch (e) {
      throw ServerException(message: 'Failed to search users: ${e.toString()}');
    }
  }

  @override
  Stream<List<FriendModel>> watchFriends(String userId) {
    return firestore
        .collection('friendships')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .asyncMap((snapshot) async {
      final friends = <FriendModel>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final friendId = data['friendId'] as String;

        final friendProfile = await firestore
            .collection('users')
            .doc(friendId)
            .get();

        if (friendProfile.exists) {
          final friendData = friendProfile.data()!;
          friends.add(FriendModel.fromFirestore({
            ...data,
            'friendName': friendData['displayName'] ?? 'Unknown',
            'friendEmail': friendData['email'] ?? '',
            'friendPhotoUrl': friendData['photoUrl'],
            'friendGmrPoints': friendData['gmrPoints'] ?? 0,
            'friendMedalLevel': friendData['medalLevel'] ?? 'Bronze',
            'friendSports': friendData['sports'] ?? [],
          }, doc.id));
        }
      }

      return friends;
    });
  }
}