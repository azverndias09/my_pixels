// utils/file_storage.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

Future<String> saveImagePermanently(File image) async {
  final directory = await getApplicationDocumentsDirectory();
  final filename = Path.basename(image.path);
  final permanentFile = File('${directory.path}/$filename');

  await image.copy(permanentFile.path);
  return permanentFile.path;
}
