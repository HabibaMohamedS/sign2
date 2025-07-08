import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonsVideoController extends GetxController {
  YoutubePlayerController? videoController;
  var isPlayerReady = false.obs;
  String? _currentVideoId;

  @override
  void onReady() {
    super.onReady();

    final lessonController = Get.find<LessonsStateManagement>();
    final int lessonIndex = lessonController.lessonIndex.value;
    final lesson = lessonController.lessons[lessonIndex];
    if (lesson.videoId == null || lesson.videoId!.isEmpty) {
      // Handle the case where videoId is not available
      log("No video ID available for lesson $lessonIndex");
      return;
    }
    // init player here "GetX already created the instance"
    initialize(lesson.videoId ?? "");
  }

  void initialize(String videoId) {
  if (_currentVideoId == videoId && videoController != null) {
    return; // Already initialized
  }

  _currentVideoId = videoId;

  videoController?.dispose();

  videoController = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  )..addListener(() {
      if (videoController!.value.isReady &&
          !isPlayerReady.value &&
          videoController!.value.playerState != PlayerState.unknown) {
        isPlayerReady.value = true;
        log("Player is ready");
      }
    });
}


  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

  void loadVideo(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? "";
    videoController?.load(videoId);
  }
}
