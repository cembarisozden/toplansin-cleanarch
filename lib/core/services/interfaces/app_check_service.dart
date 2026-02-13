import 'package:firebase_app_check/firebase_app_check.dart';

/// App Check servisi için interface
abstract class IAppCheckService {
  Future<void> activate({required AndroidProvider androidProvider});
}
