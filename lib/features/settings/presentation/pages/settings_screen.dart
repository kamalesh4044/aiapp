import 'package:flutter/material.dart';
import 'package:ai_offline_app/core/constants/theme_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _offlineMode = true;
  bool _notifications = true;
  double _modelQuality = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Text(
              'Appearance',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: ThemeConstants.primaryColor),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Text(
              'Performance',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: ThemeConstants.primaryColor),
            ),
          ),
          SwitchListTile(
            title: const Text('Offline Mode'),
            subtitle: const Text('Use offline AI models'),
            value: _offlineMode,
            onChanged: (value) {
              setState(() {
                _offlineMode = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.spacing16,
              vertical: ThemeConstants.spacing12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Model Quality: ${(_modelQuality * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: ThemeConstants.spacing8),
                Slider(
                  value: _modelQuality,
                  onChanged: (value) {
                    setState(() {
                      _modelQuality = value;
                    });
                  },
                  min: 0.5,
                  max: 1.0,
                  divisions: 5,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Text(
              'Notifications',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: ThemeConstants.primaryColor),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive app notifications'),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: ThemeConstants.primaryColor),
                ),
                const SizedBox(height: ThemeConstants.spacing12),
                Text(
                  'AI Offline Assistant v1.0.0',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: ThemeConstants.spacing4),
                Text(
                  'Lightweight AI app with offline capabilities',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
