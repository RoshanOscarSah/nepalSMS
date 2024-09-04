import 'package:get_storage/get_storage.dart';

class GetSetStorage {
  final GetStorage _box = GetStorage();

  // Clear storage
  bool clear() {
    _box.erase();
    return true;
  }

  // Generic method to write data
  bool _setData(String key, dynamic value) {
    _box.write(key, value);
    return true;
  }

  // Generic method to read data
  T _getData<T>(String key, T defaultValue) {
    return _box.read<T>(key) ?? defaultValue;
  }

  // AccessToken
  bool setAccessToken(String AccessToken) =>
      _setData('AccessToken', AccessToken);
  String getAccessToken() => _getData<String>('AccessToken', '');

  // RefreshToken
  bool setRefreshToken(String RefreshToken) =>
      _setData('RefreshToken', RefreshToken);
  String getRefreshToken() => _getData<String>('RefreshToken', '');

  // API
  bool setAPI(String api) => _setData('API', api);
  String getAPI() => _getData<String>('API', '');

  // Onboard
  bool setOnboard(bool onboard) => _setData('ONBOARD', onboard);
  bool getOnboard() => _getData<bool>('ONBOARD', true);

  // From
  bool setFrom(String from) => _setData('FROM', from);
  String getFrom() => _getData<String>('FROM', '');

  // To
  bool setTo(String to) => _setData('TO', to);
  String getTo() => _getData<String>('TO', '');

  // Location
  bool setLocation(String location) => _setData('LOCATION', location);
  String getLocation() => _getData<String>('LOCATION', '');

  // Emergency Contact 1
  bool setEmergencyContact1(String emergencyContact1) =>
      _setData('EMERGENCYCONTACT1', emergencyContact1);
  String getEmergencyContact1() => _getData<String>('EMERGENCYCONTACT1', '');

  // Emergency Contact 2
  bool setEmergencyContact2(String emergencyContact2) =>
      _setData('EMERGENCYCONTACT2', emergencyContact2);
  String getEmergencyContact2() => _getData<String>('EMERGENCYCONTACT2', '');
}
