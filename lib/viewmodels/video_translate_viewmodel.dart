import 'dart:io';
import 'package:get/get.dart';
import '../services/sign_translation_service.dart';
import '../models/sign_model.dart';

class VideoTranslateViewModel extends GetxController {
  final translationService = SignTranslationService();
  var isLoading = false.obs;
  var prediction = ''.obs;

  Future<void> translateVideo(File file) async {
    try {
      isLoading.value = true;
      final result = await translationService.uploadVideo(file);
      prediction.value = SignPrediction.fromJson(result).arabicText;
    } catch (e) {
      prediction.value = "خطأ في الترجمة";
    } finally {
      isLoading.value = false;
    }
  }
}
