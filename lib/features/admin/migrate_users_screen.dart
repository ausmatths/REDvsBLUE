// Migration Screen - Add this to your app
// File: lib/features/admin/migrate_users_screen.dart
// Navigate to this screen and press the button to migrate users

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MigrateUsersScreen extends StatefulWidget {
  const MigrateUsersScreen({super.key});

  @override
  State<MigrateUsersScreen> createState() => _MigrateUsersScreenState();
}

class _MigrateUsersScreenState extends State<MigrateUsersScreen> {
  bool _isLoading = false;
  String _status = 'Ready to migrate users';
  List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
      _status = message;
    });
    print(message);
  }

  Future<void> _migrateUsers() async {
    setState(() {
      _isLoading = true;
      _logs.clear();
      _status = 'Starting migration...';
    });

    try {
      final firestore = FirebaseFirestore.instance;

      _addLog('📥 Fetching user profiles...');

      // Get all existing userProfiles
      final userProfiles = await firestore.collection('userProfiles').get();

      _addLog('✅ Found ${userProfiles.docs.length} user profiles');

      if (userProfiles.docs.isEmpty) {
        _addLog('⚠️  No user profiles found');
        setState(() => _isLoading = false);
        return;
      }

      int successCount = 0;
      int errorCount = 0;

      // Create public profile for each user
      for (var doc in userProfiles.docs) {
        try {
          final data = doc.data();
          final userId = doc.id;

          // Extract relevant fields
          final publicProfile = {
            'displayName': data['displayName'] ??
                data['name'] ??
                data['userName'] ??
                'User',
            'email': data['email'] ?? '',
            'photoUrl': data['photoUrl'] ??
                data['profilePicture'] ??
                data['photourl'] ??
                data['avatarUrl'],
            'gmrPoints': data['gmrPoints'] ?? data['gmrpoints'] ?? 1000,
            'medalLevel': data['medalLevel'] ?? data['medallevel'] ?? 'Bronze',
            'sports': data['sports'] ?? [],
            'createdAt': data['createdAt'] ?? FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };

          // Create/update public profile
          await firestore
              .collection('users')
              .doc(userId)
              .set(publicProfile, SetOptions(merge: true));

          successCount++;
          _addLog('✅ Migrated: ${publicProfile['displayName']}');

          // Small delay to avoid overwhelming Firebase
          await Future.delayed(const Duration(milliseconds: 100));

        } catch (e) {
          errorCount++;
          _addLog('❌ Error migrating ${doc.id}: $e');
        }
      }

      _addLog('');
      _addLog('🎉 Migration Complete!');
      _addLog('✅ Success: $successCount profiles');
      if (errorCount > 0) {
        _addLog('❌ Errors: $errorCount profiles');
      }

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('✅ Migration Complete!'),
            content: Text(
                'Successfully migrated $successCount user profiles.\n\n'
                    'You can now:\n'
                    '1. Check Firebase Console\n'
                    '2. Test friend search\n'
                    '3. Close this screen'
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

    } catch (e) {
      _addLog('💥 Fatal error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrate User Profiles'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'What This Does',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will create public profiles in the "users" collection '
                          'for all existing users in "userProfiles". This allows the '
                          'Friends feature to search for users.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status
            Text(
              'Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _status,
              style: TextStyle(
                color: _isLoading ? Colors.orange : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Migrate Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _migrateUsers,
              icon: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.upload),
              label: Text(_isLoading ? 'Migrating...' : 'Start Migration'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Logs
            if (_logs.isNotEmpty) ...[
              Text(
                'Logs:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.greenAccent,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}