import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_pixels/core/app_themes.dart';
import 'package:my_pixels/data/models/gallery_image.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  final int? editIndex;
  const UploadScreen({super.key, this.editIndex});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  bool _isLoading = false;
  bool _initialPickAttempted = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger image selection when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editIndex == null) _pickAndCropImage();
    });
  }

  Future<void> _pickAndCropImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) {
      Navigator.pop(context);
      return;
    }

    final genderTheme = Theme.of(context).extension<GenderTheme>();
    final theme = Theme.of(context);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Your Image',
          toolbarColor: genderTheme?.accentColor ?? theme.primaryColor,
          toolbarWidgetColor: theme.colorScheme.onPrimary,
          activeControlsWidgetColor: genderTheme?.badgeColor,
          backgroundColor: genderTheme?.softBgColor,
          statusBarColor: genderTheme?.accentColor,
          dimmedLayerColor: Colors.black54,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          showCropGrid: false,
          cropFrameColor: genderTheme?.accentColor ?? Colors.white,
          cropGridColor:
              genderTheme?.badgeColor?.withOpacity(0.4) ?? Colors.white60,
          hideBottomControls: false,
          cropFrameStrokeWidth: 2,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          resetButtonHidden: true,
          rotateButtonsHidden: false,
          rotateClockwiseButtonHidden: true,
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
          // NO titleFontColor, toolbarHeight, tooltipColor
        ),
      ],
    );

    if (croppedFile == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _image = File(croppedFile.path));
  }

  void _saveImage() {
    if (_image == null) return;
    setState(() => _isLoading = true);

    final gallery = context.read<GalleryProvider>();
    final galleryImage = GalleryImage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      file: _image!,
      createdAt: DateTime.now(),
    );

    if (widget.editIndex != null) {
      gallery.replaceImage(widget.editIndex!, galleryImage);
    } else {
      gallery.addImage(galleryImage);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genderTheme = theme.extension<GenderTheme>();

    return Scaffold(
      backgroundColor: genderTheme?.softBgColor,
      appBar: AppBar(
        title: Text(widget.editIndex != null ? 'Edit Image' : 'Add Image'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(_image!),
                  ),
                ),
                _buildActionBar(),
              ] else ...[
                if (!_isLoading) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'Loading image...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: genderTheme?.accentColor,
                    ),
                  ),
                ],
              ],
              if (_isLoading) const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            color: Colors.green,
            onPressed: _isLoading ? null : _saveImage,
          ),
        ],
      ),
    );
  }
}
