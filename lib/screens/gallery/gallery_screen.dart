import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pixels/models/gallery_image.dart';
import 'package:my_pixels/providers/auth_provider.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:my_pixels/screens/gallery/edit_profile_screen.dart';
import 'package:my_pixels/screens/gallery/image_preview_screen.dart';
import 'package:my_pixels/screens/gallery/upload_screen.dart';
import 'package:my_pixels/widgets/gender_badge.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery').animate().fadeIn(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () => _navigateToUpload(context),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? '—'),
              accountEmail: Text(user?.email ?? '—'),
              currentAccountPicture: GenderBadge(gender: user?.gender),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pop(context);
                // should use go_router to navigate (fix later)
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: Consumer<GalleryProvider>(
        builder: (ctx, gallery, _) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ReorderableWrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              onReorder: (oldIndex, newIndex) {
                HapticFeedback.vibrate();
                gallery.reorderImages(oldIndex, newIndex);
              },
              children: [
                for (int i = 0; i < gallery.images.length; i++)
                  SizedBox(
                    key: ValueKey(gallery.images[i].id),
                    width: (MediaQuery.of(context).size.width - 24) / 2,
                    height: (MediaQuery.of(context).size.height - 200) / 3,
                    child: _buildImageTile(
                      context,
                      gallery.images[i],
                      i,
                      user?.gender,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    GalleryImage image,
    int index,
    String? gender,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        _showFullScreenPreview(context, index);
      },
      child: Stack(
        children: [
          Hero(
            tag: '${image.id}-${index == 0 ? 'editing' : 'original'}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(image.file, fit: BoxFit.cover),
            ),
          ),
          if (index == 0)
            Positioned(top: 8, right: 8, child: GenderBadge(gender: gender)),
        ],
      ),
    );
  }

  void _showFullScreenPreview(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ImagePreviewScreen(
              imageIndex: index,
              onDelete: () => _confirmDelete(context, index),
              onEdit: () => _navigateToUpload(context, index: index),
            ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Image?'),
            content: const Text('This action cannot be undone'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<GalleryProvider>(
                    context,
                    listen: false,
                  ).removeImage(index);
                  Navigator.pop(context);
                  Navigator.pop(context); // Also close the preview screen
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToUpload(BuildContext context, {int? index}) {
    // Directly open image picker need to replace this screen with upload screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadScreen(editIndex: index),
        fullscreenDialog: true,
      ),
    );
  }
}
