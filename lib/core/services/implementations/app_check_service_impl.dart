import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/app_check_service.dart';

@LazySingleton(as: IAppCheckService)
class AppCheckServiceImpl implements IAppCheckService {
  final FirebaseAppCheck _appCheck;

  AppCheckServiceImpl(this._appCheck);

  @override
  Future<void> activate({required AndroidProvider androidProvider}) async {
    await _appCheck.activate(androidProvider: androidProvider);
  }
}
