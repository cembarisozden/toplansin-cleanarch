import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:toplansin_cleanarch/core/config/env_config.dart';

/// Uygulama logger'ı - DI ile singleton
@lazySingleton
class AppLogger {
  final Logger _logger;

  AppLogger()
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
  }

  void warning(String message, {String? tag}) {
    _logger.w(_formatMessage(message, tag));
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_formatMessage(message, tag), error: error, stackTrace: stackTrace);
  }

  String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }
}

