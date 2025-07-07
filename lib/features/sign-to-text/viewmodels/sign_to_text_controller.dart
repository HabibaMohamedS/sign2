import 'dart:async';

import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sign2/core/constants/api_constants.dart';

class SignToTextController extends GetxController {
  // Using Rxn for nullable reactive variables
  final cameraController = Rxn<CameraController>();
  List<CameraDescription>? cameras;
  int currentCameraIndex = 0;

  final isRecording = false.obs;
  final isTranslating = false.obs;

  XFile? recordedVideo;
  final tts = FlutterTts();
  final originalTranslation = ''.obs; // Stores the Arabic text from the model
  final translatedText = RxnString(); // Stores the translated text
  final selectedLanguage = 'ar'.obs;  // Default language
  final List<Map<String, String>> languages = [
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
  ];

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isEmpty) return;
      await _setControllerForIndex(currentCameraIndex);
    } catch (e) {
      print("Camera initialization failed: $e");
    }
  }

  Future<void> _setControllerForIndex(int index) async {
    final desc = cameras![index];
    final ctrl = CameraController(
      desc,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await ctrl.initialize();
    cameraController.value = ctrl; // reactive assignment
  }

  Future<void> toggleCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    await cameraController.value?.dispose();
    currentCameraIndex = (currentCameraIndex + 1) % cameras!.length;
    await _setControllerForIndex(currentCameraIndex);
  }

  Future<void> recordToggle() async {
    final ctrl = cameraController.value!;
    if (isRecording.value) {
      recordedVideo = await ctrl.stopVideoRecording();
      isRecording.value = false;
      isTranslating.value = true;
      await uploadAndTranslate(recordedVideo!);
    } else {
      await ctrl.startVideoRecording();
      isRecording.value = true;
    }
  }

  // Future<void> uploadAndTranslate(XFile file) async {
  //   try {
  //     final req = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(ApiConstants.translateVideoUrl),
  //     )..files.add(await http.MultipartFile.fromPath('video', file.path));

  //     final streamed = await req.send();
  //     final respStr = await streamed.stream.bytesToString();
  //     translation.value =
  //         streamed.statusCode == 200 ? respStr : 'Error ${streamed.statusCode}';
  //   } catch (e) {
  //     translation.value = 'Upload failed: $e';
  //   } finally {
  //     isTranslating.value = false;
  //   }
  // }

  Future<void> uploadAndTranslate(XFile file) async {
  try {
      final req = http.MultipartRequest('POST', Uri.parse(ApiConstants.translateVideoUrl))
        ..files.add(await http.MultipartFile.fromPath('video', file.path));
      final res = await req.send();
      final text = await res.stream.bytesToString();
      if (res.statusCode == 200) {
        originalTranslation.value = text;         // save Arabic
        translatedText.value = text;              // show Arabic initially
        selectedLanguage.value = 'ar';            // reset dropdown
      } else {
        translatedText.value = 'Error ${res.statusCode}';
      }
    } catch (e) {
      translatedText.value = 'Upload failed: $e';
    } finally {
      isTranslating.value = false;
    }
}


  // Future<void> speakTranslation() async {
  //   if (translation.value?.isNotEmpty ?? false) {
  //     await tts.setLanguage("ar-SA");
  //     await tts.setPitch(1.0);
  //     await tts.setSpeechRate(0.5);
  //     await tts.speak(translation.value!);
  //   }
  // }

  Future<void> speakTranslation() async {
  final text = translatedText.value;
    if (text != null && text.isNotEmpty) {
      await tts.setLanguage(selectedLanguage.value);
      await tts.setSpeechRate(0.5);
      await tts.setPitch(1.0);
      await tts.speak(text);
    }
}

  ///to be implemented
  Future<void> translateToMultiLanguage() async {
  isTranslating.value = true;
    final source = originalTranslation.value.trim();
    final target = selectedLanguage.value;

    if (target == 'ar') {
      translatedText.value = source;
      isTranslating.value = false;
      return;
    }

    try {
      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(source)}&langpair=ar|$target',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mainText = data['responseData']['translatedText'];

        // Fallback to best match in 'matches' if responseData is too long
        final cleaned = mainText.toString().split(RegExp(r'[.,;:|،]')).first.trim();
        translatedText.value = cleaned.isNotEmpty ? cleaned : 'No simple translation found.';
      } else {
        translatedText.value = '77'.trParams({"status": response.statusCode.toString()});
      }
    } on TimeoutException {
      translatedText.value = '78'.tr;
    } catch (e) {
      translatedText.value = '77'.trParams({"error": e.toString()});
    } finally {
      isTranslating.value = false;
    }
}
  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }
}

// This controller manages the camera, video recording, uploading, and translation of sign language to text.
// It also handles text-to-speech for the translated text.
