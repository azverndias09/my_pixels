import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_pixels/core/app_themes.dart';
import 'package:my_pixels/models/gallery_image.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  final int? editIndex;

  const UploadScreen({super.key, this.editIndex});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<File> _images = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editIndex == null) _pickAndCropImages();
    });
  }

  Future<void> _pickAndCropImages() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked == null || picked.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final genderTheme = Theme.of(context).extension<GenderTheme>();
    final theme = Theme.of(context);

    List<File> croppedImages = [];

    for (var image in picked) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
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
          ),
        ],
      );

      if (croppedFile != null) {
        croppedImages.add(File(croppedFile.path));
      }
    }

    if (croppedImages.isNotEmpty) {
      setState(() {
        _images = croppedImages;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _saveImages() {
    if (_images.isEmpty) return;

    final gallery = context.read<GalleryProvider>();

    for (var image in _images) {
      final galleryImage = GalleryImage(
        id: Uuid().v4(),
        file: image,
        createdAt: DateTime.now(),
      );

      if (widget.editIndex != null) {
        gallery.replaceImage(widget.editIndex!, galleryImage);
      } else {
        gallery.addImage(galleryImage);
      }
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
          child:
              _images.isEmpty
                  ? const CircularProgressIndicator()
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Image.file(_images[index]),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _saveImages,
                          icon: const Icon(Icons.check),
                          label: Text(_isLoading ? 'Saving...' : 'Save'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
