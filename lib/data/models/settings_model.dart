class SettingsModel {
  final bool darkMode;
  final String language;
  final bool offlineMode;
  final bool allowNotifications;
  final double modelQuality;
  final bool autoDownloadModels;

  SettingsModel({
    this.darkMode = false,
    this.language = 'en',
    this.offlineMode = true,
    this.allowNotifications = true,
    this.modelQuality = 0.8,
    this.autoDownloadModels = false,
  });

  SettingsModel copyWith({
    bool? darkMode,
    String? language,
    bool? offlineMode,
    bool? allowNotifications,
    double? modelQuality,
    bool? autoDownloadModels,
  }) {
    return SettingsModel(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      offlineMode: offlineMode ?? this.offlineMode,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      modelQuality: modelQuality ?? this.modelQuality,
      autoDownloadModels: autoDownloadModels ?? this.autoDownloadModels,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'language': language,
      'offlineMode': offlineMode,
      'allowNotifications': allowNotifications,
      'modelQuality': modelQuality,
      'autoDownloadModels': autoDownloadModels,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      darkMode: map['darkMode'] as bool? ?? false,
      language: map['language'] as String? ?? 'en',
      offlineMode: map['offlineMode'] as bool? ?? true,
      allowNotifications: map['allowNotifications'] as bool? ?? true,
      modelQuality: map['modelQuality'] as double? ?? 0.8,
      autoDownloadModels: map['autoDownloadModels'] as bool? ?? false,
    );
  }
}
