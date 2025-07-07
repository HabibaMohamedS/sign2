import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_video_controller.dart';
import 'package:sign2/features/Learning_feature/view_model/youTube_controller.dart';
import 'package:sign2/features/onboarding/viewmodel/onboarding_controller.dart';
import 'package:sign2/features/profile/viewmodel/profile_controller.dart';
import 'package:sign2/features/splash/viewmodel/splash_controller.dart';


class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.lazyPut<LessonsStateManagement>(() => LessonsStateManagement());
    Get.lazyPut<LessonsVideoController>(() => LessonsVideoController());
    Get.lazyPut<LessonsStateManagement>(() => LessonsStateManagement());
    Get.lazyPut<YoutubePlayerGetXController>(() => YoutubePlayerGetXController());
    //onboarding 
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<ProfileController>(() => ProfileController( Get.find()));
   // Get.lazyPut<YoutubePlayerGetXController>(() => YoutubePlayerGetXController());
  }
}
