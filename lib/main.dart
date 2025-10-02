import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services
  await _initializeApp();

  runApp(
    const ProviderScope(
      child: REDvsBLUEApp(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
    // Initialize Firebase using the generated options file.
    // This now connects to the instance already initialized in index.html for web.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Hive for local storage
    await Hive.initFlutter();
    await _openHiveBoxes();

  } catch (e) {
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
