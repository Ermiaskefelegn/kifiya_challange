import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static const _storage = FlutterSecureStorage();

  SecureStorageService._();

  static Future<SecureStorageService> getInstance() async {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }
}