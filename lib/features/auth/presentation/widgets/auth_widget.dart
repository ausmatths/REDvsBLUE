import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CORRECTED: Used a prefixed import to resolve any potential naming conflicts.
import 'package:redvsblue/features/auth/presentation/providers/auth_providers.dart'
as auth_providers;
import 'package:redvsblue/features/auth/presentation/screens/login_screen.dart';
import 'package:redvsblue/features/home/presentation/screens/home_screen.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth state changes provider using the prefix
    final authState = ref.watch(auth_providers.authStateChangesProvider);

    return authState.when(
      data: (user) {
        // If user is not null (logged in), show HomeScreen
        if (user != null) {
          return const HomeScreen();
        }
        // If user is null (logged out), show LoginScreen
        return const LoginScreen();
      },
      // Show a loading spinner while checking auth state
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      // Show an error screen if something goes wrong
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Something went wrong!\n$error'),
        ),
      ),
    );
  }
}