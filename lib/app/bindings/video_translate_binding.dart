import 'package:get/get.dart';
import '../../viewmodels/video_translate_viewmodel.dart';

class VideoTranslateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoTranslateViewModel());
  }
}
