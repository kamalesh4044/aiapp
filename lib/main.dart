import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/storage_utils.dart';
import 'injection/service_locator.dart';
import 'features/chat/presentation/pages/chat_screen_online.dart';
import 'features/image_generation/presentation/pages/image_generation_screen_online.dart';
import 'features/settings/presentation/pages/settings_screen_online.dart';
import 'navigation/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtils.initialize();
  setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Online Assistant',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChatScreenOnline(chatService: getIt()),
      ImageGenerationScreenOnline(imageService: getIt()),
      const SettingsScreenOnline(),
    ];
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
