import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // On Web, use the popup flow with GoogleAuthProvider
        final googleProvider = GoogleAuthProvider();
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // On mobile (iOS/Android), use the google_sign_in package to obtain tokens
        final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

        // Try silent sign-in first (if previously authenticated)
        GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
        googleUser ??= await googleSignIn.signIn();

        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      // Create or update public profile for friend discovery
      await _createPublicProfile(userCredential.user!);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions and provide more context
      print("Firebase Auth Exception during Google Sign-In: ${e.message}");
      rethrow;
    } catch (e) {
      // Handle other potential exceptions
      print("An unexpected error occurred during Google Sign-In: $e");
      rethrow;
    }
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    if (!kIsWeb) {
      // Best-effort: also sign out of Google on mobile so next login prompts account selection
      try {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (_) {}
    }
    await _firebaseAuth.signOut();
  }

  /// Create or update public user profile for friend discovery
  /// This profile is stored in the 'users' collection (public, searchable)
  /// Separate from 'userProfiles' collection (private, only owner can see)
  Future<void> _createPublicProfile(User firebaseUser) async {
    try {
      final publicProfile = {
        'displayName': firebaseUser.displayName ?? 'User',
        'email': firebaseUser.email ?? '',
        'photoUrl': firebaseUser.photoURL,
        'gmrPoints': 1000, // Default starting points
        'medalLevel': 'Bronze', // Default medal level
        'sports': <String>[], // Empty array, user will add sports in profile
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Use SetOptions(merge: true) to avoid overwriting existing data
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(publicProfile, SetOptions(merge: true));

      print('✅ Created/updated public profile for ${firebaseUser.email}');
    } catch (e) {
      // Don't throw - profile creation shouldn't block sign-in
      print('⚠️  Error creating public profile: $e');
      // You could log this to analytics/crashlytics in production
    }
  }

  /// Update public profile when user updates their information
  /// Call this whenever the user updates their profile in the app
  Future<void> updatePublicProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
    int? gmrPoints,
    String? medalLevel,
    List<String>? sports,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (gmrPoints != null) updates['gmrPoints'] = gmrPoints;
      if (medalLevel != null) updates['medalLevel'] = medalLevel;
      if (sports != null) updates['sports'] = sports;

      await _firestore.collection('users').doc(userId).update(updates);

      print('✅ Updated public profile for user $userId');
    } catch (e) {
      print('⚠️  Error updating public profile: $e');
      // Don't rethrow - this is a background operation
    }
  }

  /// Sync private profile data to public profile
  /// Call this when user updates their profile in userProfiles collection
  Future<void> syncToPublicProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      await updatePublicProfile(
        userId: userId,
        displayName: profileData['displayName'] ?? profileData['name'],
        photoUrl: profileData['photoUrl'] ?? profileData['profilePicture'],
        gmrPoints: profileData['gmrPoints'],
        medalLevel: profileData['medalLevel'],
        sports: profileData['sports'] != null
            ? List<String>.from(profileData['sports'])
            : null,
      );
    } catch (e) {
      print('⚠️  Error syncing to public profile: $e');
    }
  }

  /// Get current user's public profile
  Future<Map<String, dynamic>?> getPublicProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('⚠️  Error fetching public profile: $e');
      return null;
    }
  }

  /// Check if public profile exists
  Future<bool> publicProfileExists(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('⚠️  Error checking public profile: $e');
      return false;
    }
  }
}