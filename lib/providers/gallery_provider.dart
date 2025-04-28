import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_pixels/models/gallery_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryProvider with ChangeNotifier {
  List<GalleryImage> _images = [];
  // static const int maxImages = 10;
  static const String _storageKey = 'gallery_images';
  List<GalleryImage> get images => _images;
  Future<void> loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      _images =
          (jsonDecode(jsonString) as List)
              .map((e) => GalleryImage.fromJson(e))
              .toList();
    }
  }

  void reorderImages(int oldI, int newI) {
    if (oldI == newI) return;
    final img = _images.removeAt(oldI);
    _images.insert(newI, img);
    notifyListeners();
  }

  Future<void> _persistImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_images));
  }

  // Call _persistImages() after every mutation - helps with retaining images or else gets deleted
  void addImage(GalleryImage image) {
    _images.add(image);
    _persistImages();
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void replaceImage(int index, GalleryImage newImage) {
    _images[index] = newImage;
    notifyListeners();
  }
}
