import 'package:camera/camera.dart';
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
  final translation = RxnString();
  XFile? recordedVideo;
  final tts = FlutterTts();

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

  Future<void> uploadAndTranslate(XFile file) async {
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.translateVideoUrl),
      )..files.add(await http.MultipartFile.fromPath('video', file.path));

      final streamed = await req.send();
      final respStr = await streamed.stream.bytesToString();
      translation.value =
          streamed.statusCode == 200 ? respStr : 'Error ${streamed.statusCode}';
    } catch (e) {
      translation.value = 'Upload failed: $e';
    } finally {
      isTranslating.value = false;
    }
  }

  Future<void> speakTranslation() async {
    if (translation.value?.isNotEmpty ?? false) {
      await tts.setLanguage("ar-SA");
      await tts.setPitch(1.0);
      await tts.setSpeechRate(0.5);
      await tts.speak(translation.value!);
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