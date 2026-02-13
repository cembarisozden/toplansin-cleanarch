import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';

/// Sayfa geçişlerini Crashlytics'e raporlar
/// Crash anında kullanıcının hangi sayfada olduğunu gösterir
@lazySingleton
class CrashlyticsRouteObserver extends NavigatorObserver {
  final ICrashlyticsService _crashlytics;

  CrashlyticsRouteObserver(this._crashlytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setCurrentScreen(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _setCurrentScreen(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _setCurrentScreen(previousRoute);
    }
  }

  void _setCurrentScreen(Route<dynamic> route) {
    final screenName = route.settings.name ?? 'unknown';
    _crashlytics.setCurrentScreen(screenName);
    _crashlytics.log('📱 Screen: $screenName');
  }
}
