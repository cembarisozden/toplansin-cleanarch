/// Firebase Messaging servisi için interface
abstract class IMessagingService {
  Future<NotificationSettings> requestPermission();
  Future<String?> getToken();
}

/// NotificationSettings - Firebase'den gelen tip
class NotificationSettings {
  final AppAuthorizationStatus authorizationStatus;
  final bool alert;
  final bool badge;
  final bool sound;

  NotificationSettings({
    required this.authorizationStatus,
    required this.alert,
    required this.badge,
    required this.sound,
  });
}

enum AppAuthorizationStatus {
  notDetermined,
  denied,
  authorized,
  provisional,
}
