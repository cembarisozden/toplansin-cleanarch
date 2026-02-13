import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IOnboardingLocalDatasource {
  bool isOnboardingSeen();           // Future gerek yok, sync
  Future<void> setOnboardingSeen();
}

@LazySingleton(as: IOnboardingLocalDatasource)
class OnboardingLocalDatasourceImpl implements IOnboardingLocalDatasource {
  final SharedPreferences _prefs;
  static const String _key = 'onboarding_seen';

  OnboardingLocalDatasourceImpl(this._prefs);

  @override
  bool isOnboardingSeen() {
    return _prefs.getBool(_key) ?? false;  // sync - Future gereksiz
  }

  @override
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_key, true);
  }
} 