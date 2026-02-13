import 'package:firebase_messaging/firebase_messaging.dart' as firebase_messaging;
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/messaging_service.dart';

@LazySingleton(as: IMessagingService)
class MessagingServiceImpl implements IMessagingService {
  final firebase_messaging.FirebaseMessaging _messaging;

  MessagingServiceImpl(this._messaging);

  @override
  Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return NotificationSettings(
      authorizationStatus: _mapAuthorizationStatus(settings.authorizationStatus),
      alert: settings.alert == firebase_messaging.AppleNotificationSetting.enabled,
      badge: settings.badge == firebase_messaging.AppleNotificationSetting.enabled,
      sound: settings.sound == firebase_messaging.AppleNotificationSetting.enabled,
    );
  }

  @override
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  AppAuthorizationStatus _mapAuthorizationStatus(
    firebase_messaging.AuthorizationStatus firebaseStatus,
  ) {
    switch (firebaseStatus) {
      case firebase_messaging.AuthorizationStatus.notDetermined:
        return AppAuthorizationStatus.notDetermined;
      case firebase_messaging.AuthorizationStatus.denied:
        return AppAuthorizationStatus.denied;
      case firebase_messaging.AuthorizationStatus.authorized:
        return AppAuthorizationStatus.authorized;
      case firebase_messaging.AuthorizationStatus.provisional:
        return AppAuthorizationStatus.provisional;
    }
  }
}
