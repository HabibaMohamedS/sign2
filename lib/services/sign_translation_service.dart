import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sign2/core/constants/api_constants.dart';

class SignTranslationService {

  Future<String> uploadVideo(File videoFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.translateVideoUrl),
    );
    request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception("Failed to translate video");
    }
  }
}
