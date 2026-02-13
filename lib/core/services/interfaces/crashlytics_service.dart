/// Crashlytics servisi için interface
/// Hata raporlama, kullanıcı takibi ve custom key yönetimi
abstract class ICrashlyticsService {
  /// Crashlytics'i aktif/pasif yapar
  Future<void> setCrashlyticsCollectionEnabled(bool enabled);

  /// Kullanıcı ID'sini set eder (login sonrası)
  Future<void> setUserIdentifier(String userId);

  /// Kullanıcı ID'sini temizler (logout sonrası)
  Future<void> clearUserIdentifier();

  /// Custom key ekler (sayfa, işlem vs.)
  Future<void> setCustomKey(String key, dynamic value);

  /// Breadcrumb log ekler (kullanıcı yolculuğu)
  Future<void> log(String message);

  /// Non-fatal hata kaydeder
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Flutter framework hatalarını yakalar
  void recordFlutterError(dynamic details);

  /// Mevcut ekranı set eder
  Future<void> setCurrentScreen(String screenName);

  /// App version ve build number'ı set eder
  Future<void> setAppVersion(String version, String buildNumber);

  /// Device bilgilerini set eder (opsiyonel)
  Future<void> setDeviceInfo({
    String? deviceModel,
    String? osVersion,
    String? platform,
  });
}
