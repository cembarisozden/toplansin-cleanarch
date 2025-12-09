import 'package:firebase_core/firebase_core.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/firebase_options_dev.dart' as dev;
import 'package:toplansin_cleanarch/firebase_options_prod.dart' as prod;

/// Firebase yapılandırması - ortama göre doğru options'ı döner
class FirebaseConfig {
  static FirebaseOptions get currentOptions {
    switch (EnvConfig.current) {
      case Environment.dev:
        return dev.DefaultFirebaseOptions.currentPlatform;
      case Environment.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: currentOptions);
  }
}

