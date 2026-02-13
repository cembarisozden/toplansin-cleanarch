/// Remote Config servisi için interface
abstract class IRemoteConfigService {
  Future<void> setConfigSettings({
    required Duration fetchTimeout,
    required Duration minimumFetchInterval,
  });
  Future<bool> fetchAndActivate();
}
