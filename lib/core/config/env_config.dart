/// Uygulama ortam yapılandırması
/// --dart-define=ENV=dev veya ENV=prod ile belirlenir
enum Environment { dev, prod }

class EnvConfig {
  static Environment get current {
    const envString = String.fromEnvironment('ENV', defaultValue: 'dev');
    return envString == 'prod' ? Environment.prod : Environment.dev;
  }

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;

  static String get appName {
    switch (current) {
      case Environment.dev:
        return 'Toplansın Dev';
      case Environment.prod:
        return 'Toplansın';
    }
  }

  static String get appSuffix {
    switch (current) {
      case Environment.dev:
        return ' [DEV]';
      case Environment.prod:
        return '';
    }
  }
}

