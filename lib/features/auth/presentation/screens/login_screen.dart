import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Import your providers and repository
import '../providers/auth_providers.dart';
// NOTE: We don't need to import the repository directly anymore,
// as we get it from the provider.

// Change to a ConsumerWidget to access providers
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can now read the repository provider
    final authRepository = ref.watch(authRepositoryProvider);
    final bool isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD32F2F), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Text(
                    'REDvsBLUE',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Match. Play. Compete.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                        ref.read(loadingProvider.notifier).state = true;
                        try {
                          await authRepository.signInWithGoogle();
                          // Navigation is handled by AuthWidget, no need for context.go()
                        } catch (e) {
                          // Handle potential errors, e.g., user closes the popup
                          debugPrint("Sign-in failed: $e");
                        } finally {
                          // Ensure loading state is always turned off
                          if (context.mounted) {
                            ref.read(loadingProvider.notifier).state = false;
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(color: Colors.white),
                  ],

                  const SizedBox(height: 40),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white54)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("OR", style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(child: Divider(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Other login options can be added here
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text(
                      'Sign up with Email',
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// A simple provider to handle loading state
final loadingProvider = StateProvider<bool>((ref) => false);