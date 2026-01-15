import 'package:flutter/material.dart';
import 'package:ai_offline_app/core/constants/theme_constants.dart';
import 'package:ai_offline_app/ml/models/image_model_handler.dart';
import 'dart:typed_data';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({Key? key}) : super(key: key);

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _promptController = TextEditingController();
  final List<String> _styles = ['Default', 'Realistic', 'Artistic', 'Cartoon'];
  String _selectedStyle = 'Default';
  bool _isGenerating = false;
  late ImageModelHandler _imageModel;
  Uint8List? _generatedImage;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    _imageModel = ImageModelHandlerImpl();
    try {
      await _imageModel.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing image model: $e')),
        );
      }
    }
  }

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt first!')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final image = await _imageModel.generateImage(
        _promptController.text,
        style: _selectedStyle,
      );

      if (mounted) {
        setState(() {
          _generatedImage = image;
          _isGenerating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ Image generated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating image: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _imageModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Generated Image Preview
            if (_generatedImage != null) ...[
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium - 4),
                  child: Image.memory(_generatedImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: ThemeConstants.spacing24),
            ],

            // Prompt Input
            Text(
              'Enter your prompt',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: ThemeConstants.spacing12),
            TextField(
              controller: _promptController,
              maxLines: 4,
              enabled: !_isGenerating,
              decoration: InputDecoration(
                hintText: 'Describe the image you want to generate...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.radiusMedium,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing24),

            // Style Selection
            Text(
              'Select Style',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: ThemeConstants.spacing12),
            Wrap(
              spacing: ThemeConstants.spacing12,
              children: _styles
                  .map((style) => FilterChip(
                        label: Text(style),
                        selected: _selectedStyle == style,
                        onSelected: _isGenerating
                            ? null
                            : (selected) {
                                setState(() {
                                  _selectedStyle = selected ? style : _selectedStyle;
                                });
                              },
                      ))
                  .toList(),
            ),
            const SizedBox(height: ThemeConstants.spacing32),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConstants.primaryColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isGenerating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Generate Image',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),

            // Status Text
            if (_isGenerating) ...[
              const SizedBox(height: ThemeConstants.spacing24),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(height: ThemeConstants.spacing12),
                    Text(
                      'Generating image with $_selectedStyle style...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
