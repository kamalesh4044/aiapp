class AppConstants {
  // App info
  static const String appName = 'AI Offline';
  static const String appVersion = '1.0.0';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String modelsDownloadedKey = 'models_downloaded';
  
  // Timing
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Pagination
  static const int pageSize = 20;
  static const int initialLoadSize = 10;
  
  // Cache duration (in days)
  static const int cacheDuration = 7;
  
  // File size limits (in MB)
  static const int maxImageSize = 10;
  static const int maxUploadSize = 50;
}
