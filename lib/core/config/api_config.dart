/// API Configuration for online AI services
/// 
/// This file contains all API configuration including:
/// - OpenAI API keys and endpoints
/// - Model settings
/// - Rate limits and timeouts

class ApiConfig {
  // OpenAI Configuration
  static const String openaiApiKey = 'your_openai_api_key_here';
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  
  // GPT Models
  static const String gptModel = 'gpt-3.5-turbo';
  static const String gptModelFallback = 'gpt-3.5-turbo';
  static const int gptMaxTokens = 2000;
  static const double gptTemperature = 0.7;
  
  // DALL-E Image Generation
  static const String dalleModel = 'dall-e-3';
  static const String dalleSize = '1024x1024'; // Options: 256x256, 512x512, 1024x1024
  static const String dalleQuality = 'standard'; // Options: standard, hd
  static const int dalleImagesPerRequest = 1;
  
  // Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 60;
  static const int sendTimeout = 60;
  
  // Rate Limiting
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;
  
  // Update API key at runtime
  static String _apiKey = openaiApiKey;
  
  static String get apiKey => _apiKey;
  static void setApiKey(String key) {
    _apiKey = key;
  }
  
  // Endpoint helpers
  static String getEndpoint(String path) {
    return '$openaiBaseUrl/$path';
  }
}

/// Environment configuration
enum Environment { development, production }

class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.production;
  
  static bool get isProduction => currentEnvironment == Environment.production;
  static bool get isDevelopment => currentEnvironment == Environment.development;
  
  // Enable debug logging
  static const bool enableDebugLogs = true;
}
