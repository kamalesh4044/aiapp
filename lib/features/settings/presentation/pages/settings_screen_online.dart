import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/http_client.dart';
import '../../../../injection/service_locator.dart';
import '../../../../data/services/openai_service.dart';

class SettingsScreenOnline extends StatefulWidget {
  const SettingsScreenOnline({Key? key}) : super(key: key);

  @override
  State<SettingsScreenOnline> createState() => _SettingsScreenOnlineState();
}

class _SettingsScreenOnlineState extends State<SettingsScreenOnline> {
  late TextEditingController _apiKeyController;
  bool _showApiKey = false;
  String? _apiKeyStatus = 'Not set';

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: ApiConfig.apiKey);
    _checkApiKeyStatus();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _checkApiKeyStatus() {
    final apiKey = ApiConfig.apiKey;
    if (apiKey.isEmpty || apiKey == 'your_openai_api_key_here') {
      setState(() => _apiKeyStatus = '❌ Not configured');
    } else if (apiKey.startsWith('sk-')) {
      setState(() => _apiKeyStatus = '✅ Configured (${apiKey.substring(0, 6)}...)');
    } else {
      setState(() => _apiKeyStatus = '⚠️ Invalid format');
    }
  }

  void _saveApiKey() {
    final newKey = _apiKeyController.text.trim();

    if (newKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key cannot be empty')),
      );
      return;
    }

    if (!newKey.startsWith('sk-')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key should start with "sk-"')),
      );
      return;
    }

    // Update the API key in all services
    getIt<HttpClient>().setApiKey(newKey);
    ApiConfig.setApiKey(newKey);

    _checkApiKeyStatus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API key updated successfully!')),
    );
  }

  Future<void> _testApiKey() async {
    final newKey = _apiKeyController.text.trim();
    
    if (newKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key first')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Testing API key...')),
      );

      // Update key first
      getIt<HttpClient>().setApiKey(newKey);
      ApiConfig.setApiKey(newKey);

      final chatService = getIt<OpenAIChatService>();
      
      final response = await chatService.sendMessage(
        'Say: Test successful',
      );

      if (response.content.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ API key is valid and working!'),
            backgroundColor: Colors.green,
          ),
        );
        _checkApiKeyStatus();
      }
    } on DioException catch (e) {
      String errorMsg = 'API test failed';
      if (e.response?.statusCode == 401) {
        errorMsg = '❌ Invalid API key (401)';
      } else if (e.response?.statusCode == 429) {
        errorMsg = '❌ Rate limited (429)';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = '❌ Connection timeout';
      } else {
        errorMsg = '❌ ${e.response?.statusCode} - ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
        elevation: 0,
        backgroundColor: Colors.grey.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Key Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.vpn_key, color: Colors.blue),
                        const SizedBox(width: 12),
                        const Text(
                          'OpenAI API Key',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(_apiKeyStatus ?? 'Unknown'),
                          backgroundColor: _apiKeyStatus?.contains('✅') == true
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: !_showApiKey,
                      decoration: InputDecoration(
                        hintText: 'sk-...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showApiKey ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _showApiKey = !_showApiKey);
                          },
                        ),
                        prefixIcon: const Icon(Icons.key),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Get your API key from: https://platform.openai.com/api-keys',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveApiKey,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Key'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testApiKey,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Test Key'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Models Configuration
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.smart_toy, color: Colors.purple),
                        SizedBox(width: 12),
                        Text(
                          'AI Models',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildConfigItem(
                      'Chat Model',
                      ApiConfig.gptModel,
                      'GPT-4 Turbo for advanced conversations',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Image Model',
                      ApiConfig.dalleModel,
                      'DALL-E 3 for image generation',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Max Tokens (Chat)',
                      '${ApiConfig.gptMaxTokens}',
                      'Maximum response length',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Temperature',
                      '${ApiConfig.gptTemperature}',
                      'Creativity level (0=precise, 2=creative)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image Settings
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.image, color: Colors.orange),
                        SizedBox(width: 12),
                        Text(
                          'Image Generation Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildConfigItem(
                      'Default Size',
                      ApiConfig.dalleSize,
                      'Output image dimensions',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Quality',
                      ApiConfig.dalleQuality.toUpperCase(),
                      'Standard or HD quality',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Network Settings
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.teal),
                        SizedBox(width: 12),
                        Text(
                          'Network Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildConfigItem(
                      'API Endpoint',
                      ApiConfig.openaiBaseUrl,
                      'OpenAI API base URL',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Connect Timeout',
                      '${ApiConfig.connectTimeout}s',
                      'Time to establish connection',
                    ),
                    const Divider(),
                    _buildConfigItem(
                      'Receive Timeout',
                      '${ApiConfig.receiveTimeout}s',
                      'Time to receive response',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This app uses OpenAI APIs for:\n\n'
                    '• GPT-4 Turbo for intelligent conversations\n'
                    '• DALL-E 3 for image generation\n'
                    '• GPT-4 Vision for image analysis\n\n'
                    'Visit https://openai.com/pricing for API pricing.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(String title, String value, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
