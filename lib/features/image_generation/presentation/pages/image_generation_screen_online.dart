import 'package:flutter/material.dart';
import '../../../../data/services/openai_service.dart';

class ImageGenerationScreenOnline extends StatefulWidget {
  final OpenAIImageService imageService;

  const ImageGenerationScreenOnline({
    Key? key,
    required this.imageService,
  }) : super(key: key);

  @override
  State<ImageGenerationScreenOnline> createState() =>
      _ImageGenerationScreenOnlineState();
}

class _ImageGenerationScreenOnlineState
    extends State<ImageGenerationScreenOnline> {
  final TextEditingController _promptController = TextEditingController();
  final List<String> _generatedImages = [];
  bool _isLoading = false;
  String? _selectedSize = '1024x1024';
  String? _selectedQuality = 'standard';
  int _numberOfImages = 1;

  final List<String> _sizes = ['256x256', '512x512', '1024x1024'];
  final List<String> _qualities = ['standard', 'hd'];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateImages() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedImages.clear();
    });

    try {
      final images = await widget.imageService.generateImages(
        _promptController.text,
        size: _selectedSize,
        quality: _selectedQuality,
        numberOfImages: _numberOfImages,
      );

      setState(() {
        _generatedImages.addAll(images);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images generated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generator'),
        elevation: 0,
        backgroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prompt Input
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: 'Describe the image you want to create...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.image),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Size Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image Size',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return FilterChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSize = selected ? size : null;
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Colors.purple.shade700,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quality Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quality',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _qualities.map((quality) {
                        final isSelected = _selectedQuality == quality;
                        return FilterChip(
                          label: Text(quality.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedQuality = selected ? quality : null;
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Colors.purple.shade700,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Number of Images
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Number of Images',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _numberOfImages.toDouble(),
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_numberOfImages',
                      onChanged: (value) {
                        setState(() {
                          _numberOfImages = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Generate Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateImages,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isLoading ? 'Generating...' : 'Generate Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generated Images Grid
            if (_generatedImages.isNotEmpty) ...[
              const Text(
                'Generated Images',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _generatedImages.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.network(
                          _generatedImages[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: FloatingActionButton.small(
                            onPressed: () {
                              // TODO: Implement share/download
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Download/Share feature coming soon'),
                                ),
                              );
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(
                              Icons.download,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else if (!_isLoading)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No images generated yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
