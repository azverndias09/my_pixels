import 'package:flutter/material.dart';
import 'package:my_pixels/providers/auth_provider.dart';
import 'package:my_pixels/providers/gallery_provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_pixels/core/app_themes.dart';

import 'package:my_pixels/routes/app_router.dart'; // Import this correctly

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: Builder(
        builder: (context) {
          final gender = context.watch<UserProvider>().user?.gender ?? 'Male';
          return MaterialApp.router(
            title: 'Pixel Gallery',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme(gender),
            routerConfig: appRouter, // ✅ just use appRouter directly
          );
        },
      ),
    );
  }
}
