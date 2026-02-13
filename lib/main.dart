import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toplansin_cleanarch/app.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/config/firebase_config.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';
import 'package:toplansin_cleanarch/scripts/seed_firestore_venues.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Edge-to-edge ekran modu
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );

      // 1. Önce Firebase
      await FirebaseConfig.initialize();

      // 2. Sonra DI
      await configureDependencies();

      // (Opsiyonel) Firestore'a mock venue'leri ekle: flutter run --dart-define=SEED_VENUES=true
      if (const bool.fromEnvironment('SEED_VENUES', defaultValue: false)) {
        await seedFirestoreVenues(sl<FirebaseFirestore>());
      }

      // 3. Crashlytics global error handlers
      final crashlytics = sl<ICrashlyticsService>();

      // Production'da collection'ı aç, dev'de kapat
      await crashlytics.setCrashlyticsCollectionEnabled(!EnvConfig.isDev);

      // Flutter framework hataları
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        crashlytics.recordFlutterError(details);
      };

      final logger = sl<AppLogger>();
      final appCheck = sl<FirebaseAppCheck>();

      await appCheck.activate(
        // 🟢 Android: Dev'de veya Debug modda debug, Prod Release'de Play Integrity
        providerAndroid: (EnvConfig.isDev || kDebugMode)
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),

        // 🍎 iOS: Dev'de veya Debug modda debug, Prod Release'de DeviceCheck
        providerApple: (EnvConfig.isDev || kDebugMode)
            ? const AppleDebugProvider()
            : const AppleDeviceCheckProvider(),
      );
      // App Check token'ını log'la
      try {
        final appCheckToken = await appCheck.getToken();
        if (appCheckToken != null) {
          logger.info('🛡️ App Check token obtained');
          logger.debug(
            '🛡️ App Check token (first 30 chars): ${appCheckToken.length > 30 ? appCheckToken.substring(0, 30) : appCheckToken}...',
          );
        } else {
          logger.warning('⚠️ App Check token is null!');
        }
      } catch (e) {
        logger.warning(
          '⚠️ App Check token error (will retry on function call): $e',
        );
      }

      // Platform dispatcher hataları (async hatalar)
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      // 4. Logger

      logger.info(
        '🔥 Firebase initialized: ${EnvConfig.current.name.toUpperCase()}',
      );
      logger.debug('💉 Dependencies configured');
      logger.debug('🛡️ Crashlytics configured');

      runApp(const ToplansinApp());
    },
    (error, stackTrace) {
      // Zone içindeki yakalanmamış hatalar
      if (!EnvConfig.isDev) {
        sl<ICrashlyticsService>().recordError(error, stackTrace, fatal: true);
      }
    },
  );
}
