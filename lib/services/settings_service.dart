import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write({required String key, required String value});
  Future<void> delete(String key);
}

abstract class LegacyPreferencesStore {
  String? getString(String key);
  Future<void> remove(String key);
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  FlutterSecureKeyValueStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class SharedPreferencesLegacyStore implements LegacyPreferencesStore {
  SharedPreferencesLegacyStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

class SettingsService {
  SettingsService({
    SecureKeyValueStore? secureStore,
    Future<LegacyPreferencesStore> Function()? legacyStoreLoader,
  }) : _secureStore = secureStore ?? FlutterSecureKeyValueStore(),
       _legacyStoreLoader =
           legacyStoreLoader ??
           (() => SharedPreferences.getInstance().then(
             SharedPreferencesLegacyStore.new,
           ));

  static const apiKeyKey = 'omdb_api_key';

  final SecureKeyValueStore _secureStore;
  final Future<LegacyPreferencesStore> Function() _legacyStoreLoader;

  Future<String> getApiKey() async {
    final secureValue = (await _secureStore.read(apiKeyKey))?.trim() ?? '';
    if (secureValue.isNotEmpty) {
      return secureValue;
    }

    return _migrateLegacyApiKeyIfNeeded();
  }

  Future<void> saveApiKey(String apiKey) async {
    final normalized = apiKey.trim();
    if (normalized.isEmpty) {
      await _secureStore.delete(apiKeyKey);
    } else {
      await _secureStore.write(key: apiKeyKey, value: normalized);
    }

    final legacyStore = await _legacyStoreLoader();
    await legacyStore.remove(apiKeyKey);
  }

  Future<String> _migrateLegacyApiKeyIfNeeded() async {
    final legacyStore = await _legacyStoreLoader();
    final legacyValue = legacyStore.getString(apiKeyKey)?.trim() ?? '';

    if (legacyValue.isEmpty) {
      return '';
    }

    await _secureStore.write(key: apiKeyKey, value: legacyValue);
    await legacyStore.remove(apiKeyKey);
    return legacyValue;
  }
}
