import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_pixels/models/gallery_image.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/gallery_provider.dart';
import 'package:my_pixels/core/app_themes.dart';

class ImageEditorScreen extends StatefulWidget {
  final int? editIndex;

  const ImageEditorScreen({super.key, this.editIndex});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  File? _image;
  bool _isLoading = false;
  String? _errorMessage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.editIndex != null) {
      final existingImage =
          context.read<GalleryProvider>().images[widget.editIndex!];
      _image = existingImage.file;
    }
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
          ),
        ],
      );

      if (cropped != null) {
        setState(() => _image = File(cropped.path));
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to select or crop image.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _saveImage() {
    if (_image == null) return;

    final galleryProvider = context.read<GalleryProvider>();

    if (widget.editIndex != null) {
      final updatedImage = GalleryImage(
        id: galleryProvider.images[widget.editIndex!].id,
        file: _image!,
        createdAt: galleryProvider.images[widget.editIndex!].createdAt,
      );
      galleryProvider.replaceImage(widget.editIndex!, updatedImage);
    } else {
      final newImage = GalleryImage(
        id: Uuid().v4(),
        file: _image!,
        createdAt: DateTime.now(),
      );
      galleryProvider.addImage(newImage);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genderTheme = theme.extension<GenderTheme>();

    if (genderTheme == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add/Edit Image')),
        body: const Center(child: Text('Error: Gender theme not found')),
      );
    }

    return Scaffold(
      backgroundColor: genderTheme.accentColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text(widget.editIndex != null ? 'Edit Image' : 'Add New Image'),
        actions: [
          if (_image != null && !_isLoading)
            IconButton(icon: const Icon(Icons.check), onPressed: _saveImage),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child:
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child:
                              _image != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : _buildPlaceholder(),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      _buildControlBar(),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, size: 50),
            const SizedBox(height: 10),
            Text(
              'Tap to select image',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            onPressed: _pickImage,
          ),
          if (_image != null)
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => setState(() => _image = null),
            ),
        ],
      ),
    );
  }
}
