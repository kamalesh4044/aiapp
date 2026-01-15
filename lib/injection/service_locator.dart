import 'package:get_it/get_it.dart';
import '../core/network/http_client.dart';
import '../data/services/openai_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Network & HTTP
  getIt.registerSingleton<HttpClient>(HttpClient());

  // API Services
  getIt.registerSingleton<OpenAIChatService>(
    OpenAIChatService(getIt<HttpClient>()),
  );
  getIt.registerSingleton<OpenAIImageService>(
    OpenAIImageService(getIt<HttpClient>()),
  );
  getIt.registerSingleton<OpenAIVisionService>(
    OpenAIVisionService(getIt<HttpClient>()),
  );
}
