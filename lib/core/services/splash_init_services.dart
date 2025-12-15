// lib/core/services/splash_init_service.dart
import 'package:injectable/injectable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';

@injectable
class SplashInitService {
  final FirebaseRemoteConfig _remoteConfig;
  final FirebaseAppCheck _appCheck;
  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final AppLogger _logger;

  SplashInitService(this._remoteConfig, this._appCheck, this._messaging, this._auth, this._logger);

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
      _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(hours: 1),
      )).then((_) => _remoteConfig.fetchAndActivate()),
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
  await Future.delayed(minTaskDelay);
  final user = _auth.currentUser;
  _logger.debug('✅ Auth check: ${user != null ? 'logged in' : 'guest'}');
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
  bool get isLoggedIn => _auth.currentUser != null;
}