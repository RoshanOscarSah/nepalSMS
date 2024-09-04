import 'package:get_storage/get_storage.dart';

class GetSetStorage {
  final GetStorage _box = GetStorage();

  // Clear storage
  bool clear() {
    _box.erase();
    return true;
  }

  // Generic method to write data
  bool _setData(String key, String value) {
    _box.write(key, value);
    return true;
  }

  // Generic method to read data
  String _getData(String key) {
    return _box.read<String>(key) ?? "";
  }

  // Access Token
  bool setAccessToken(String accessToken) => _setData('accessToken', accessToken);
  String getAccessToken() => _getData('accessToken');

  // Refresh Token
  bool setRefreshToken(String refreshToken) => _setData('refreshToken', refreshToken);
  String getRefreshToken() => _getData('refreshToken');

 
}
