import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/repositories/auth_repository.dart';

// Provides the FirebaseAuth instance
final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Provides the GoogleSignIn instance WITH the Web Client ID
final googleSignInProvider = Provider<GoogleSignIn>(
      (ref) => GoogleSignIn(
    clientId: '614515570879-h94qs6f332d4fr2529q58l6rv79p4q1p.apps.googleusercontent.com',
  ),
);

// Provides the AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>(
  // CORRECTED: Switched to named arguments as required by the constructor.
      (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

// Provides the stream of authentication state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

