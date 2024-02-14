import 'dart:convert';
import 'dart:io';

class ReadJson {
  static Future<Map<String, dynamic>?> read(String path) async {
    try {
      File file = File(path);
      String content = await file.readAsString();

      Map<String, dynamic> jsonData = jsonDecode(content);
      return jsonData;
    } catch (e) {
      return null;
    }
  }
}
