import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import Firebase Core and your options file
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';

void main() async {
  // This is essential to use `await` before `runApp`
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all external services
  await _initializeApp();

  runApp(
    const ProviderScope(
      child: REDvsBLUEApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
    // THIS IS THE CRUCIAL LINE: It tells your Flutter app to connect to Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set preferred device orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize local storage
    await Hive.initFlutter();
    await _openHiveBoxes();

  } catch (e) {
    // This will print any errors that happen during initialization
    debugPrint('Error during app initialization: $e');
  }
}

Future<void> _openHiveBoxes() async {
  try {
    await Hive.openBox('user_preferences');
    await Hive.openBox('cached_matches');
    await Hive.openBox('cached_venues');
    await Hive.openBox('app_settings');
  } catch (e) {
    debugPrint('Error opening Hive boxes: $e');
  }
}
