import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';

@LazySingleton(as: ICrashlyticsService)
class CrashlyticsServiceImpl implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsServiceImpl(this._crashlytics);

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  @override
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> clearUserIdentifier() async {
    await _crashlytics.setUserIdentifier('');
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace ?? StackTrace.current,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  void recordFlutterError(dynamic details) {
    if (details is FlutterErrorDetails) {
      _crashlytics.recordFlutterFatalError(details);
    }
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    await _crashlytics.setCustomKey('current_screen', screenName);
  }

  @override
  Future<void> setAppVersion(String version, String buildNumber) async {
    await _crashlytics.setCustomKey('app_version', version);
    await _crashlytics.setCustomKey('build_number', buildNumber);
  }

  @override
  Future<void> setDeviceInfo({
    String? deviceModel,
    String? osVersion,
    String? platform,
  }) async {
    if (deviceModel != null) {
      await _crashlytics.setCustomKey('device_model', deviceModel);
    }
    if (osVersion != null) {
      await _crashlytics.setCustomKey('os_version', osVersion);
    }
    if (platform != null) {
      await _crashlytics.setCustomKey('platform', platform);
    }
  }
}
