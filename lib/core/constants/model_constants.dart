class ModelConstants {
  // Model names
  static const String chatModelName = 'chat_model.tflite';
  static const String imageGenModelName = 'image_gen_model.tflite';
  
  // Model paths
  static const String modelsDirectory = 'assets/models';
  static const String chatModelPath = '$modelsDirectory/chat_model.tflite';
  static const String imageGenModelPath = '$modelsDirectory/image_gen_model.tflite';
  
  // Model sizes (approximate in MB)
  static const int chatModelSize = 50;
  static const int imageGenModelSize = 100;
  
  // Input/Output configurations
  static const int chatInputLength = 512;
  static const int chatOutputLength = 512;
  
  static const int imageGenInputSize = 256;
  static const int imageGenOutputSize = 512;
  
  // Quantization settings
  static const bool useQuantization = true;
  static const String quantizationType = 'int8'; // int8 or float16
}
