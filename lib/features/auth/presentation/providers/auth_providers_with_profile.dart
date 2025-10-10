// lib/features/auth/presentation/providers/auth_providers_with_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_with_profile.dart';
import '../../../profile/presentation/providers/user_profile_providers.dart';

// Provides the FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Provides the AuthRepository instance with profile creation
final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    profileRepository: ref.watch(userProfileRepositoryProvider),
  ),
);

// Provides the stream of authentication state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Provides the current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});