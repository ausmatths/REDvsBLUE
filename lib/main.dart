import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ADD: Import Firebase Core and your options file
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';

void main() async {
  // Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services, including Firebase
  await _initializeApp();

  runApp(
    const ProviderScope(
      child: REDvsBLUEApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
    // --- ADDED THIS BLOCK ---
    // Initialize Firebase using the generated options file
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // -----------------------

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Open Hive boxes
    await _openHiveBoxes();

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    // It's very helpful to print any initialization errors
    debugPrint('Initialization Error: $e');
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
