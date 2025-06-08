import 'package:get/get.dart';
import '../../views/video_translate_screen.dart';
import '../bindings/video_translate_binding.dart';

class AppPages {
  static const initial = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => VideoTranslateScreen(),
      binding: VideoTranslateBinding(),
    ),
  ];
}
