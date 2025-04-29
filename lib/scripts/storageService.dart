import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late final Directory _dir;

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
  }

  File getUserJsonFile(String filename) {
    final jsonDir = Directory('${_dir.path}/user_jsons');
    if (!jsonDir.existsSync()) {
      jsonDir.createSync(recursive: true);
    }
    return File('${jsonDir.path}/$filename.json');
  }
}
