import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Quick script to create public user profiles from existing userProfiles
/// This allows the Friends feature to search for users
///
/// Run this ONCE: dart run lib/scripts/migrate_users.dart

Future<void> main() async {
  print('🚀 Starting user profile migration...\n');

  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  try {
    // Get all existing userProfiles
    print('📥 Fetching user profiles...');
    final userProfiles = await firestore.collection('userProfiles').get();
    print('✅ Found ${userProfiles.docs.length} user profiles\n');

    if (userProfiles.docs.isEmpty) {
      print('⚠️  No user profiles found in userProfiles collection');
      print('   Make sure users are created first!');
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
              data['avatarUrl'],
          'gmrPoints': data['gmrPoints'] ?? 1000,
          'medalLevel': data['medalLevel'] ?? 'Bronze',
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
        print('✅ Created public profile for: ${publicProfile['displayName']} (${publicProfile['email']})');

      } catch (e) {
        errorCount++;
        print('❌ Error creating profile for ${doc.id}: $e');
      }
    }

    print('\n' + '=' * 50);
    print('🎉 Migration Complete!');
    print('=' * 50);
    print('✅ Success: $successCount profiles created');
    if (errorCount > 0) {
      print('❌ Errors: $errorCount profiles failed');
    }
    print('\n📍 Next steps:');
    print('   1. Check Firebase Console → Firestore → users collection');
    print('   2. Deploy updated Firebase rules (see FIX_NO_USERS_FOUND.md)');
    print('   3. Test friend search in the app');
    print('\n');

  } catch (e) {
    print('💥 Fatal error: $e');
  }
}