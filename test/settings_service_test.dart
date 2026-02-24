import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/services/settings_service.dart';

class InMemorySecureStore implements SecureKeyValueStore {
  final Map<String, String> _storage = {};

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _storage[key] = value;
  }
}

class InMemoryLegacyStore implements LegacyPreferencesStore {
  InMemoryLegacyStore(this._storage);

  final Map<String, String> _storage;

  @override
  String? getString(String key) => _storage[key];

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }
}

void main() {
  group('SettingsService', () {
    test('salva e lê API key no armazenamento seguro', () async {
      final secureStore = InMemorySecureStore();
      final legacyMap = <String, String>{};
      final service = SettingsService(
        secureStore: secureStore,
        legacyStoreLoader: () async => InMemoryLegacyStore(legacyMap),
      );

      await service.saveApiKey('  my-key-123  ');
      final apiKey = await service.getApiKey();

      expect(apiKey, 'my-key-123');
      expect(legacyMap.containsKey(SettingsService.apiKeyKey), isFalse);
    });

    test(
      'migra API key legada do SharedPreferences para armazenamento seguro',
      () async {
        final secureStore = InMemorySecureStore();
        final legacyMap = <String, String>{
          SettingsService.apiKeyKey: 'legacy-key',
        };
        final service = SettingsService(
          secureStore: secureStore,
          legacyStoreLoader: () async => InMemoryLegacyStore(legacyMap),
        );

        final apiKey = await service.getApiKey();

        expect(apiKey, 'legacy-key');
        expect(await secureStore.read(SettingsService.apiKeyKey), 'legacy-key');
        expect(legacyMap.containsKey(SettingsService.apiKeyKey), isFalse);
      },
    );

    test('não sobrescreve valor seguro quando legado existe', () async {
      final secureStore = InMemorySecureStore();
      await secureStore.write(
        key: SettingsService.apiKeyKey,
        value: 'secure-key',
      );
      final legacyMap = <String, String>{
        SettingsService.apiKeyKey: 'legacy-key',
      };
      final service = SettingsService(
        secureStore: secureStore,
        legacyStoreLoader: () async => InMemoryLegacyStore(legacyMap),
      );

      final apiKey = await service.getApiKey();

      expect(apiKey, 'secure-key');
      expect(legacyMap[SettingsService.apiKeyKey], 'legacy-key');
    });
  });
}
