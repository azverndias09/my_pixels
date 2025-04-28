import 'package:flutter/material.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:provider/provider.dart';

class ImagePreviewScreen extends StatelessWidget {
  final int imageIndex;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ImagePreviewScreen({
    super.key,
    required this.imageIndex,
    required this.onDelete,
    required this.onEdit,
  });
  @override
  Widget build(BuildContext context) {
    final galleryProvider = Provider.of<GalleryProvider>(context);
    final images = galleryProvider.images;

    int safeIndex = imageIndex; // Create a local copy

    if (safeIndex >= images.length) {
      if (images.isEmpty) {
        Navigator.of(context).pop(); // No images left
        return const SizedBox(); // Empty widget after pop
      }
      safeIndex = images.length - 1; // revert to last valid index
    }

    final image = images[safeIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: image.id,
          child: Image.file(image.file, fit: BoxFit.contain),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.black.withOpacity(0.7),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.edit,
              label: 'Edit',
              onPressed: onEdit,
            ),
            _buildActionButton(
              icon: Icons.delete,
              label: 'Delete',
              onPressed: onDelete,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: isDestructive ? Colors.red : Colors.white),
      label: Text(
        label,
        style: TextStyle(color: isDestructive ? Colors.red : Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
