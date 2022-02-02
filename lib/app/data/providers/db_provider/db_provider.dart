import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';

class DatabaseProvider extends GetConnect {
  late final GetStorage _getStorage;
  late final FlutterSecureStorage _secureStorage;

  Future<DatabaseProvider> init() async {
    await GetStorage.init();
    _getStorage = GetStorage();
    _secureStorage = FlutterSecureStorage();

    return this;
  }

  T? read<T>(String key) {
    final value = _getStorage.read<T>(key);
    // print('-------------------read-----------------------');
    // print('key: $key');
    // print('value: $value');
    // print('Type: $T');
    // print('-------------------read-----------------------');
    return value;
  }

  Future<void> write(String key, dynamic value) =>
      _getStorage.write(key, value);

  Future<String?> readSecure(String key) async {
    final value = await _secureStorage.read(key: key);
    // print('\n-------------------readSecure-----------------------');
    // print('key: $key');
    // print('value: $value');
    // print('-------------------readSecure-----------------------');
    return value;
  }

  Future<void> writeSecure(String key, dynamic value) async {
    // print('\n-------------------writeSecure-----------------------');
    // print('key: $key');
    // print('value: $value');
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> deleteSecureAll() async {
    // print('\n-------------------deleteSecureAll-----------------------');
    await _secureStorage.deleteAll();
  }

  Future<void> deleteKey(String key) async {
    await _getStorage.write(key, null);
  }
}
