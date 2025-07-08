import 'dart:developer';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerGetXController extends GetxController {
  late YoutubePlayerController youtubePlayerController;
  final LessonsStateManagement lessonController = Get.find<LessonsStateManagement>();

  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
    ever(lessonController.lessonIndex, (_) => initializePlayer());
  }

  Future<void> initializePlayer() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final lessonIndex = lessonController.lessonIndex.value;
      final lessons = lessonController.lessons;

      // Validate index and video ID
      if (lessonIndex < 0 || lessonIndex >= lessons.length) {
        log("Invalid lesson index: $lessonIndex");
      }

      final videoId = lessons[lessonIndex].videoId ?? "";
      if (videoId.isEmpty) log("Video ID is empty") ;

      // Dispose old controller if it exists
      if (youtubePlayerController != null) {
        youtubePlayerController.dispose();
      }

      // Initialize new controller
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );

      // Track player readiness
      youtubePlayerController.addListener(_handlePlayerState);

      isLoading.value = false;

    } catch (e) {
      errorMessage.value = "Failed to load video: $e";
      isLoading.value = false;
      youtubePlayerController.dispose();
    }
  }

  void _handlePlayerState() {
    if (youtubePlayerController.value.hasError) {
      errorMessage.value = youtubePlayerController.value.errorCode.toString();
    }
  }

  @override
  void onClose() {
    youtubePlayerController.removeListener(_handlePlayerState);
    youtubePlayerController.dispose();
    super.onClose();
  }

  void togglePlayback() {
    if (youtubePlayerController.value.isPlaying) {
      youtubePlayerController.pause();
    } else {
      youtubePlayerController.play();
    }
  }
}