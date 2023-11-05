import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileService {
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> saveFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      await file.copy('storage/emulated/0/Download/$fileName');
    } 
  }

  Future<void> writeFile(String data, File file) async {
    await file.writeAsString(data);
  }

  Future<String> readFile(File file) async {
    return file.readAsString();
  }

  Future<List<Map<String, dynamic>>> readJsonFile(File file) async {
    String content = await readFile(file);
    List<dynamic> jsonData = jsonDecode(content);
    return jsonData.cast<Map<String, dynamic>>();
  }

  Future<void> writeJsonFile(List<Map<String, dynamic>> data, File file) async {
    String jsonStr = jsonEncode(data);
    await writeFile(jsonStr, file);
  }
}
