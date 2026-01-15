import 'package:flutter/material.dart';
import 'package:ai_offline_app/core/constants/theme_constants.dart';
import 'package:ai_offline_app/core/widgets/custom_text_field.dart';
import 'package:ai_offline_app/ml/models/chat_model_handler.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late ChatModelHandler _chatModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    _chatModel = ChatModelHandlerImpl();
    try {
      await _chatModel.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing chat: $e')),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    final userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _isLoading = true;
    });

    try {
      final response = await _chatModel.inference(userMessage);
      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': response});
          _isLoading = false;
        });
        // Scroll to bottom
        Future.delayed(const Duration(milliseconds: 100), () {
          // Auto scroll would be implemented with ScrollController
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'Sorry, I encountered an error: $e'});
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chatModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(ThemeConstants.spacing16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: ThemeConstants.spacing16),
                          Text(
                            'Start a conversation',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: ThemeConstants.spacing12),
                          Text(
                            'Try saying hello or asking a question!',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(ThemeConstants.spacing16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      final isUser = message['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: ThemeConstants.spacing12,
                          ),
                          padding: const EdgeInsets.all(
                            ThemeConstants.spacing12,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? ThemeConstants.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              ThemeConstants.radiusMedium,
                            ),
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: isUser
                                  ? ThemeConstants.textInverse
                                  : ThemeConstants.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.spacing12),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: ThemeConstants.spacing12),
                  Text(
                    'AI is thinking...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _controller,
                    hint: 'Type a message...',
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacing12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(ThemeConstants.spacing12),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
