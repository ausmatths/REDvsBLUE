import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';

// Provides the FirebaseAuth instance
final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Provides the AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
  ),
);

// Provides the stream of authentication state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

