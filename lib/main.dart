import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slack_clone_gautam_manwani/app.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/app_storage.dart';
import 'package:slack_clone_gautam_manwani/dependency_injector.dart';
import 'package:slack_clone_gautam_manwani/firebase_options.dart';

/// Main entry point of the application
Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await AppStorage().init();

  // Inject dependencies
  DependencyInjector.inject();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the app
  runApp(const MyApp());
}
