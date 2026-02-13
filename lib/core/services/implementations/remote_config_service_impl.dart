import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/remote_config_service.dart';

@LazySingleton(as: IRemoteConfigService)
class RemoteConfigServiceImpl implements IRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigServiceImpl(this._remoteConfig);

  @override
  Future<void> setConfigSettings({
    required Duration fetchTimeout,
    required Duration minimumFetchInterval,
  }) async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: fetchTimeout,
      minimumFetchInterval: minimumFetchInterval,
    ));
  }

  @override
  Future<bool> fetchAndActivate() async {
    return await _remoteConfig.fetchAndActivate();
  }
}
