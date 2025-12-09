import 'package:flutter/foundation.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';

/// Uygulama logger'ı
class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) {
    if (EnvConfig.isDev) {
      _log('DEBUG', message, tag: tag);
    }
  }

  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  static void warning(String message, {String? tag}) {
    _log('WARNING', message, tag: tag);
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, tag: tag);
    if (error != null) {
      debugPrint('Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  static void _log(String level, String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag] ' : '';
    debugPrint('[$level] $tagStr$message');
  }
}

