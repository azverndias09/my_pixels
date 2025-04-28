import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:my_pixels/app.dart';

// main.dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  final galleryProvider = GalleryProvider();

  // await userProvider.initialize();
  // await galleryProvider.loadImages();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: galleryProvider),
      ],
      child: const AppEntry(),
    ),
  );
}
