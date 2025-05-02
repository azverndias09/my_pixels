import 'dart:io';
import 'package:uuid/uuid.dart';

class GalleryImage {
  final String id;
  final File file;
  final DateTime createdAt;

  GalleryImage({required this.file, required this.createdAt, required this.id});

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': file.path,
    'createdAt': createdAt.toIso8601String(),
  };

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
    id: json['id'],
    file: File(json['path']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}
