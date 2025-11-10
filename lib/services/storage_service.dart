import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageKeys {
  static const String themeMode = 'theme_mode';
  static const String clockCheck = "clock";
}

class StorageService extends GetxController {
  bool _initialized = false; // 🔹 Tek seferlik init koruması
  late SharedPreferences _preferences;
  final RxList<String> favorites = <String>[].obs;

  bool get isInitialized => _initialized; // 🔹 Splash'ta kullanılacak

  Future<StorageService> init() async {
    if (_initialized) return this; // ✅ İkinci kez init etmeyi engelle
    _preferences = await SharedPreferences.getInstance();
    _initialized = true;
    return this;
  }

  Future<bool> setValue<T>(String key, T value) async {
    try {
      if (value is String) {
        return await _preferences.setString(key, value);
      } else if (value is int) {
        return await _preferences.setInt(key, value);
      } else if (value is double) {
        return await _preferences.setDouble(key, value);
      } else if (value is bool) {
        return await _preferences.setBool(key, value);
      } else if (value is List<String>) {
        return await _preferences.setStringList(key, value);
      } else {
        throw ArgumentError("Desteklenmeyen veri türü");
      }
    } catch (e) {
      print("Veri eklenirken hata oluştu: $e");
      return false;
    }
  }

  T? getValue<T>(String key) {
    try {
      final value = _preferences.get(key);
      return value == null ? null : value as T?;
    } catch (e) {
      print("Veri storagedan okunurken hata çıktı: $e");
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      print("Key silinirken hata oluştu: $e");
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      print("clear fonksiyonunda hata oluştu: $e");
      return false;
    }
  }

  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }

  T getValueOrDefault<T>(String key, T defaultValue) {
    return getValue<T>(key) ?? defaultValue;
    // 🔹 null ise varsayılan döner
  }

  Map<String, dynamic> getAllValues() {
    final keys = _preferences.getKeys();
    final map = <String, dynamic>{};
    for (var key in keys) {
      map[key] = _preferences.get(key);
    }
    return map;
  }
}
