// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeApp();

  runApp(
    const ProviderScope(
      child: REDvsBLUEApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
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
    debugPrint('Initialization Error: $e');
  }
}

Future<void> _openHiveBoxes() async {
  try {
    // Open boxes for different data types
    await Hive.openBox('user_preferences');
    await Hive.openBox('cached_matches');
    await Hive.openBox('cached_venues');
    await Hive.openBox('app_settings');
  } catch (e) {
    debugPrint('Error opening Hive boxes: $e');
  }
}