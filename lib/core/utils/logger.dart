import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';

/// Uygulama logger'ı - DI ile singleton
/// Crashlytics entegrasyonu ile production'da hataları raporlar
@lazySingleton
class AppLogger {
  final Logger _logger;
  final ICrashlyticsService _crashlytics;

  AppLogger(this._crashlytics)
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          ),
          level: EnvConfig.isDev ? Level.debug : Level.info,
        );

  void debug(String message, {String? tag}) {
    if (EnvConfig.isDev) {
      _logger.d(_formatMessage(message, tag));
    }
  }

  void info(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
    // Production'da breadcrumb olarak kaydet
    if (!EnvConfig.isDev) {
      _crashlytics.log(_formatMessage(message, tag));
    }
  }

  void warning(String message, {String? tag}) {
    _logger.w(_formatMessage(message, tag));
    // Production'da breadcrumb olarak kaydet
    if (!EnvConfig.isDev) {
      _crashlytics.log('⚠️ ${_formatMessage(message, tag)}');
    }
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_formatMessage(message, tag), error: error, stackTrace: stackTrace);
    
    // Production'da Crashlytics'e non-fatal error olarak gönder
    if (!EnvConfig.isDev) {
      _crashlytics.recordError(
        error ?? Exception(message),
        stackTrace,
        reason: tag ?? message,
        fatal: false,
      );
    }
  }

  String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }
}
