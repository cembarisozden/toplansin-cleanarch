import 'package:flutter/material.dart';
import 'package:toplansin_cleanarch/app.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/config/firebase_config.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Önce Firebase
  await FirebaseConfig.initialize();

  // 2. Sonra DI
  await configureDependencies();

  // 3. Artık DI'dan alabilirsin
  final logger = sl<AppLogger>();
  logger.info('🔥 Firebase initialized: ${EnvConfig.current.name.toUpperCase()}');
  logger.debug('💉 Dependencies configured');

  runApp(const ToplansinApp());
}
