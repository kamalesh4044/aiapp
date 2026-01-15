import 'package:flutter/material.dart';

class AppRouter {
  static const String home = '/';
  static const String chat = '/chat';
  static const String imageGeneration = '/image-generation';
  static const String imageUpload = '/image-upload';
  static const String history = '/history';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
      case chat:
      case imageGeneration:
      case imageUpload:
      case history:
      case settings:
        // Routes will be handled by the main navigation widget
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route: ${settings.name}'),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
