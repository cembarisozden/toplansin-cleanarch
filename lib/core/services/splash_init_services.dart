// lib/core/services/splash_init_service.dart
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/app_check_service.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/auth_service.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/messaging_service.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/remote_config_service.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';

@injectable
class SplashInitService {
  final IRemoteConfigService _remoteConfig;
  final IAppCheckService _appCheck;
  final IMessagingService _messaging;
  final IAuthService _auth;
  final AppLogger _logger;
  final ICrashlyticsService _crashlytics;

  SplashInitService(
    this._remoteConfig,
    this._appCheck,
    this._messaging,
    this._auth,
    this._logger,
    this._crashlytics,
  );

  /// Her task'ın ağırlığı (toplam 1.0 olmalı)
  static const _taskWeights = {
    'appCheck': 0.15,
    'remoteConfig': 0.25,
    'fcmToken': 0.20,
    'authCheck': 0.20,
    'preload': 0.20,
  };

  /// Stream olarak progress döner (0.0 - 1.0)

 Stream<double> initialize() async* {
  _logger.info('🚀 Splash initialization started');
  double completed = 0;
  
  const minTaskDelay = Duration(milliseconds: 400); // Her task min 400ms

  // 0. Crashlytics tracking setup (app version & device info)
  try {
    await _setupCrashlyticsTracking();
    _logger.debug('✅ Crashlytics tracking configured');
  } catch (e) {
    _logger.warning('⚠️ Crashlytics tracking failed: $e');
  }

  // 1. App Check
  try {
    await Future.wait([
      _appCheck.activate(androidProvider: AndroidProvider.playIntegrity),
      Future.delayed(minTaskDelay),
    ]);
    _logger.debug('✅ App Check activated');
  } catch (e) {
    await Future.delayed(minTaskDelay);
    _logger.warning('⚠️ App Check failed: $e');
  }
  completed += _taskWeights['appCheck']!;
  yield completed;

  // 2. Remote Config
  try {
    await Future.wait([
      _remoteConfig
          .setConfigSettings(
            fetchTimeout: const Duration(seconds: 5),
            minimumFetchInterval: const Duration(hours: 1),
          )
          .then((_) => _remoteConfig.fetchAndActivate()),
      Future.delayed(minTaskDelay),
    ]);
    _logger.debug('✅ Remote Config fetched');
  } catch (e) {
    await Future.delayed(minTaskDelay);
    _logger.warning('⚠️ Remote Config failed: $e');
  }
  completed += _taskWeights['remoteConfig']!;
  yield completed;

  // 3. FCM Token
  try {
    await Future.wait([
      _messaging.requestPermission().then((_) => _messaging.getToken()),
      Future.delayed(minTaskDelay),
    ]);
    _logger.debug('✅ FCM Token received');
  } catch (e) {
    await Future.delayed(minTaskDelay);
    _logger.warning('⚠️ FCM failed: $e');
  }
  completed += _taskWeights['fcmToken']!;
  yield completed;

  // 4. Auth Check
// 4. Auth Check
try {
  await Future.delayed(minTaskDelay);
  final user = _auth.currentUser;
  _logger.debug('✅ Auth check: ${user != null ? 'logged in' : 'guest'}');
} catch (e) {
  await Future.delayed(minTaskDelay);
  _logger.warning('⚠️ Auth check failed: $e');
}
completed += _taskWeights['authCheck']!;
yield completed;

  // 5. Preload
  await Future.delayed(minTaskDelay);
  _logger.debug('✅ Preload complete');
  completed += _taskWeights['preload']!;
  yield completed;

  _logger.info('🎉 Splash initialization completed');
  }

  /// Kullanıcı giriş yapmış mı?
  bool get isLoggedIn => _auth.isLoggedIn;

  /// Crashlytics tracking setup - app version ve device info
  Future<void> _setupCrashlyticsTracking() async {
    // App version & build number
    final packageInfo = await PackageInfo.fromPlatform();
    await _crashlytics.setAppVersion(
      packageInfo.version,
      packageInfo.buildNumber,
    );

    // Device info (opsiyonel - hata olursa devam et)
    try {
      final deviceInfo = DeviceInfoPlugin();
      String? deviceModel;
      String? osVersion;
      String? platform;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
        osVersion = 'Android ${androidInfo.version.release}';
        platform = 'Android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.model;
        osVersion = 'iOS ${iosInfo.systemVersion}';
        platform = 'iOS';
      }

      await _crashlytics.setDeviceInfo(
        deviceModel: deviceModel,
        osVersion: osVersion,
        platform: platform,
      );
    } catch (e) {
      // Device info opsiyonel, hata olursa devam et
      _logger.debug('Device info not available: $e');
    }
  }
}