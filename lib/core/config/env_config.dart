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
  static String get googleServerClientId {
    switch (current) {
      case Environment.dev:
        return '450533363306-d4brjosdi56qca96vl1nnoh31plm8o1c.apps.googleusercontent.com';
      case Environment.prod:
        return '450679317964-lotlj5m3ak8h8d84c3f379iu9pr90a53.apps.googleusercontent.com';
    }
  }


  static String get appleClientId {
  switch (current) {
    case Environment.dev:
      return 'com.toplansin.toplansin.dev'; // iOS Bundle ID veya Service ID
    case Environment.prod:
      return 'com.toplansin.toplansin';
  }
}

static String get appleRedirectUri {
  switch (current) {
    case Environment.dev:
      return 'https://toplansin-dev.firebaseapp.com/__/auth/handler';
    case Environment.prod:
      return 'https://toplansin-e4363.firebaseapp.com/__/auth/handler';
  }
}
}

