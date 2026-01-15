import '../models/settings_model.dart';
import '../../core/utils/storage_utils.dart';
import '../../core/constants/app_constants.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings(SettingsModel settings);
  Future<void> resetSettings();
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsModel? _cachedSettings;

  @override
  Future<SettingsModel> getSettings() async {
    if (_cachedSettings != null) return _cachedSettings!;

    try {
      final themeMode = StorageUtils.getString(AppConstants.themeKey);
      final language = StorageUtils.getString(AppConstants.languageKey);
      
      _cachedSettings = SettingsModel(
        darkMode: themeMode == 'dark',
        language: language ?? 'en',
      );

      return _cachedSettings!;
    } catch (e) {
      return SettingsModel();
    }
  }

  @override
  Future<void> updateSettings(SettingsModel settings) async {
    _cachedSettings = settings;
    
    await StorageUtils.saveBool(AppConstants.themeKey, settings.darkMode);
    await StorageUtils.saveString(AppConstants.languageKey, settings.language);
    await StorageUtils.saveBool('offlineMode', settings.offlineMode);
    await StorageUtils.saveBool('allowNotifications', settings.allowNotifications);
    await StorageUtils.saveDouble('modelQuality', settings.modelQuality);
    await StorageUtils.saveBool('autoDownloadModels', settings.autoDownloadModels);
  }

  @override
  Future<void> resetSettings() async {
    _cachedSettings = null;
    await StorageUtils.clear();
  }
}
