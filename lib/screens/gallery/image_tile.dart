import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pixels/models/gallery_image.dart';
// import 'package:my_pixels/widgets/gender_badge.dart';

class ImageTile extends StatelessWidget {
  final GalleryImage image;
  final int index;
  final String gender;
  final bool isExpanded;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const ImageTile({
    super.key,
    required this.image,
    required this.index,
    required this.gender,
    required this.isExpanded,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Main Image Content
          Hero(
            tag: image.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(image.file, fit: BoxFit.cover),
            ),
          ),

          // Gender Badge for first image
          // if (index == 0)
          //   const Positioned(
          //     top: 8,
          //     right: 8,
          //     child: GenderBadge(gender),
          //   ),

          // Edit/Delete Options when expanded
          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black54,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onEdit();
                      },
                    ),

                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        onDelete();
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// Compare this snippet from my_pixels