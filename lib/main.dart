// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all necessary services
  await _initializeApp();

  runApp(
    const ProviderScope(
      child: REDvsBLUEApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
    // Set preferred screen orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Firebase using the generated options file
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Open Hive boxes that will be used for caching
    await _openHiveBoxes();

    // Set the system UI overlay style for a clean look
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    // Log any errors that occur during initialization
    debugPrint('Initialization Error: $e');
  }
}

Future<void> _openHiveBoxes() async {
  try {
    // Open boxes for different types of cached data
    await Hive.openBox('user_preferences');
    await Hive.openBox('cached_matches');
    await Hive.openBox('cached_venues');
    await Hive.openBox('app_settings');
  } catch (e) {
    debugPrint('Error opening Hive boxes: $e');
  }
}
