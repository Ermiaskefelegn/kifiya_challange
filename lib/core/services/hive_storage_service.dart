import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:kifiya_challenge/core/services/log_service.dart';

class HiveStorageService {
  static HiveStorageService? _instance;
  static Box? _box;
  static const String _boxName = 'app_storage';
  final LogService logService;

  HiveStorageService._({required this.logService});

  static Future<HiveStorageService> getInstance() async {
    final logService = await GetIt.instance.getAsync<LogService>();
    _instance ??= HiveStorageService._(logService: logService);
    _box ??= await Hive.openBox(_boxName);
    logService.info('HiveStorageService initialized, box: $_boxName');
    return _instance!;
  }

  Future<void> set(String key, dynamic value) async {
    if (_box == null) {
      logService.error('Hive box not initialized for set: $key');
      throw Exception('Hive box is not initialized');
    }
    logService.debug('Setting key: $key, value: $value');
    await _box!.put(key, value);
    logService.info('Set key: $key successfully');
  }

  T? get<T>(String key) {
    if (_box == null) {
      logService.error('Hive box not initialized for get: $key');
      return null;
    }
    logService.debug('Getting key: $key');
    final value = _box!.get(key) as T?;
    logService.info('Retrieved key: $key, value: $value');
    return value;
  }

  Future<bool> containsKey(String key) async {
    if (_box == null) {
      logService.error('Hive box not initialized for containsKey: $key');
      throw Exception('Hive box is not initialized');
    }
    logService.debug('Checking if key exists: $key');
    final exists = _box!.containsKey(key);
    logService.info('Key $key exists: $exists');
    return exists;
  }

  Future<void> delete(String key) async {
    if (_box == null) {
      logService.error('Hive box not initialized for delete: $key');
      throw Exception('Hive box is not initialized');
    }
    logService.debug('Deleting key: $key');
    await _box!.delete(key);
    logService.info('Deleted key: $key');
  }

  Future<void> clear() async {
    if (_box == null) {
      logService.error('Hive box not initialized for clear');
      throw Exception('Hive box is not initialized');
    }
    logService.debug('Clearing all data in box: $_boxName');
    await _box!.clear();
    logService.info('Cleared box: $_boxName');
  }

  List<String> getAllKeys() {
    if (_box == null) {
      logService.error('Hive box not initialized for getAllKeys');
      return [];
    }
    logService.debug('Retrieving all keys');
    final keys = _box!.keys.cast<String>().toList();
    logService.info('Retrieved keys: $keys');
    return keys;
  }
}
