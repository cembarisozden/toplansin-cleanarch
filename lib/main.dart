import 'package:flutter/material.dart';
import 'package:toplansin_cleanarch/app.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/config/firebase_config.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection başlat
  await configureDependencies();
  AppLogger.debug('💉 Dependencies configured');

  // Firebase başlat
  await FirebaseConfig.initialize();
  AppLogger.info('🔥 Firebase initialized: ${EnvConfig.current.name.toUpperCase()}');

  // Uygulamayı başlat
  runApp(const ToplansinApp());
}
