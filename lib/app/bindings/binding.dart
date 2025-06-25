import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_video_controller.dart';
import 'package:sign2/features/Learning_feature/view_model/youTube_controller.dart';
import 'package:sign2/features/onboarding/viewmodel/onboarding_controller.dart';
import 'package:sign2/features/splash/viewmodel/splash_controller.dart';


class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonsStateManagement>(() => LessonsStateManagement());
    Get.lazyPut<LessonsVideoController>(() => LessonsVideoController());
    Get.lazyPut<LessonsStateManagement>(() => LessonsStateManagement());
    Get.lazyPut<YoutubePlayerGetXController>(() => YoutubePlayerGetXController());
    //onboarding 
    // Get.put(StorageService(), permanent: true);
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<SplashController>(() => SplashController());
   // Get.lazyPut<YoutubePlayerGetXController>(() => YoutubePlayerGetXController());
  }
}
