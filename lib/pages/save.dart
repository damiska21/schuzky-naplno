import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  //zdroj: https://docs.flutter.dev/cookbook/persistence/reading-writing-files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.txt');
  }

  Future<String> read() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    return contents;
  }

  Future<File> write(String programy) async {
    final file = await _localFile;
    return file.writeAsString(programy);
  }
}
