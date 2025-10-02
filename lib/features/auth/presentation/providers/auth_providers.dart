import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Import the repository
import '../../data/repositories/auth_repository.dart';

// This provider exposes the FirebaseAuth instance
final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// This provider exposes the GoogleSignIn instance
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// This provider creates and exposes an instance of your AuthRepository
final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

// This provider creates a stream that notifies the app whenever the user's authentication state changes.
// The app will listen to this to know if a user is logged in or out.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // CORRECTED: The authStateChanges stream comes directly from FirebaseAuth, not the repository.
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

