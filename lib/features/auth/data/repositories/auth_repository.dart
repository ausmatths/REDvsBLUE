import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // On Web, use the popup flow with GoogleAuthProvider
        final googleProvider = GoogleAuthProvider();
        return await _firebaseAuth.signInWithPopup(googleProvider);
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
        return await _firebaseAuth.signInWithCredential(credential);
      }
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
}