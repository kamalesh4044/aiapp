import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_offline_app/core/constants/theme_constants.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _uploadImage() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image uploaded successfully!')),
    );

    setState(() {
      _selectedImage = null;
      _descriptionController.clear();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage == null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeConstants.borderColor),
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.radiusMedium,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: ThemeConstants.textTertiary,
                      ),
                      const SizedBox(height: ThemeConstants.spacing16),
                      Text(
                        'No image selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              Image.network(
                _selectedImage!.path,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: ThemeConstants.borderColor,
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
            const SizedBox(height: ThemeConstants.spacing24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacing12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.spacing24),
            Text(
              'Description (optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: ThemeConstants.spacing12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a description for this image...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.radiusMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Upload Image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
