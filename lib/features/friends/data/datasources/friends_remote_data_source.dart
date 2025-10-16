import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/friend_model.dart';

/// Remote data source for Friends - handles Firebase operations
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

/// Implementation using Firebase Firestore
class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final FirebaseFirestore firestore;

  FriendsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FriendModel>> getFriends(String userId) async {
    try {
      // Get all friendships where user is either userId or friendId AND status is accepted
      final userFriendships = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      final friendFriendships = await firestore
          .collection('friendships')
          .where('friendId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      final friends = <FriendModel>[];

      // Process user's sent requests that were accepted
      for (var doc in userFriendships.docs) {
        final data = doc.data();
        final friendId = data['friendId'] as String;

        // Fetch friend's profile from users collection
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

      // Process received requests that were accepted
      for (var doc in friendFriendships.docs) {
        final data = doc.data();
        final friendId = data['userId'] as String;

        // Fetch friend's profile
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

      // Check reverse direction
      final reverseExisting = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: friendId)
          .where('friendId', isEqualTo: userId)
          .get();

      if (reverseExisting.docs.isNotEmpty) {
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

      // Create friendship document
      final docRef = await firestore.collection('friendships').add({
        'userId': userId,
        'friendId': friendId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Return the created friendship with friend data
      final createdDoc = await docRef.get();
      return FriendModel.fromFirestore({
        ...createdDoc.data()!,
        'friendName': friendData['displayName'] ?? 'Unknown',
        'friendEmail': friendData['email'] ?? '',
        'friendPhotoUrl': friendData['photoUrl'],
        'friendGmrPoints': friendData['gmrPoints'] ?? 0,
        'friendMedalLevel': friendData['medalLevel'] ?? 'Bronze',
        'friendSports': friendData['sports'] ?? [],
      }, docRef.id);
    } catch (e) {
      if (e is ValidationException || e is NotFoundExceptionCustom) {
        rethrow;
      }
      throw ServerException(message: 'Failed to send friend request: ${e.toString()}');
    }
  }

  @override
  Future<FriendModel> acceptFriendRequest(String requestId) async {
    try {
      final docRef = firestore.collection('friendships').doc(requestId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw NotFoundExceptionCustom(message: 'Friend request not found');
      }

      // Update status to accepted
      await docRef.update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final data = doc.data()!;
      final friendId = data['userId'] as String;

      // Get friend profile
      final friendProfile = await firestore
          .collection('users')
          .doc(friendId)
          .get();

      final friendData = friendProfile.data()!;

      return FriendModel.fromFirestore({
        ...data,
        'status': 'accepted',
        'friendName': friendData['displayName'] ?? 'Unknown',
        'friendEmail': friendData['email'] ?? '',
        'friendPhotoUrl': friendData['photoUrl'],
        'friendGmrPoints': friendData['gmrPoints'] ?? 0,
        'friendMedalLevel': friendData['medalLevel'] ?? 'Bronze',
        'friendSports': friendData['sports'] ?? [],
      }, requestId);
    } catch (e) {
      if (e is NotFoundExceptionCustom) {
        rethrow;
      }
      throw ServerException(message: 'Failed to accept friend request: ${e.toString()}');
    }
  }

  @override
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      final docRef = firestore.collection('friendships').doc(requestId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw NotFoundExceptionCustom(message: 'Friend request not found');
      }

      // Update status to rejected
      await docRef.update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (e is NotFoundExceptionCustom) {
        rethrow;
      }
      throw ServerException(message: 'Failed to reject friend request: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFriend(String friendshipId) async {
    try {
      await firestore.collection('friendships').doc(friendshipId).delete();
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
      // Find and update any existing friendships
      final existing = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: userId)
          .where('friendId', isEqualTo: blockedUserId)
          .get();

      for (var doc in existing.docs) {
        await doc.reference.update({
          'status': 'blocked',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Check reverse direction
      final reverseExisting = await firestore
          .collection('friendships')
          .where('userId', isEqualTo: blockedUserId)
          .where('friendId', isEqualTo: userId)
          .get();

      for (var doc in reverseExisting.docs) {
        await doc.reference.update({
          'status': 'blocked',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
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

      // Search in users collection
      final snapshot = await firestore.collection('users').get();

      final results = <FriendModel>[];

      for (var doc in snapshot.docs) {
        if (doc.id == currentUserId) continue; // Skip current user

        final data = doc.data();
        final displayName = (data['displayName'] ?? '').toString().toLowerCase();
        final email = (data['email'] ?? '').toString().toLowerCase();

        if (displayName.contains(queryLower) || email.contains(queryLower)) {
          results.add(FriendModel.fromFirestore({
            'userId': currentUserId,
            'friendId': doc.id,
            'friendName': data['displayName'] ?? 'Unknown',
            'friendEmail': data['email'] ?? '',
            'friendPhotoUrl': data['photoUrl'],
            'friendGmrPoints': data['gmrPoints'] ?? 0,
            'friendMedalLevel': data['medalLevel'] ?? 'Bronze',
            'friendSports': data['sports'] ?? [],
            'status': 'none',
            'createdAt': Timestamp.now(),
          }, 'search_${doc.id}'));
        }
      }

      return results;
    } catch (e) {
      throw ServerException(message: 'Failed to search users: ${e.toString()}');
    }
  }

  @override
  Stream<List<FriendModel>> watchFriends(String userId) {
    try {
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
    } catch (e) {
      throw ServerException(message: 'Failed to watch friends: ${e.toString()}');
    }
  }
}