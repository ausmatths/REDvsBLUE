// lib/features/auth/data/repositories/auth_repository_with_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../profile/domain/entities/user_profile_entity.dart';
import '../../../profile/domain/repositories/user_profile_repository.dart';

/// Enhanced AuthRepository that creates user profiles on signup
///
/// This ensures every new user gets a profile in Firestore
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final UserProfileRepository _profileRepository;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    required UserProfileRepository profileRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _profileRepository = profileRepository;

  /// Signs in with Google and creates profile if new user
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

      // Check if this is a new user and create profile
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createInitialProfile(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception during Google Sign-In: ${e.message}");
      rethrow;
    } catch (e) {
      print("An unexpected error occurred during Google Sign-In: $e");
      rethrow;
    }
  }

  /// Signs in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception during email sign-in: ${e.message}");
      rethrow;
    }
  }

  /// Creates a new account with email and password and initial profile
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      // Create initial profile
      await _createInitialProfile(userCredential.user!);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception during registration: ${e.message}");
      rethrow;
    }
  }

  /// Signs out
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

  /// Gets current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Creates initial profile for a new user
  Future<void> _createInitialProfile(User user) async {
    try {
      // Check if profile already exists
      final existsResult = await _profileRepository.profileExists(user.uid);
      final exists = existsResult.fold((l) => false, (r) => r);

      if (exists) {
        print('Profile already exists for user: ${user.uid}');
        return;
      }

      // Create initial profile
      final profile = UserProfileEntity.initial(
        userId: user.uid,
        displayName: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      final result = await _profileRepository.createProfile(profile);

      result.fold(
            (failure) {
          print('Failed to create profile: ${failure.message}');
          // Don't throw - allow auth to succeed even if profile creation fails
          // Profile can be created later
        },
            (profile) {
          print('Successfully created profile for user: ${user.uid}');
        },
      );
    } catch (e) {
      print('Error creating initial profile: $e');
      // Don't throw - allow auth to succeed even if profile creation fails
    }
  }
}