import 'package:get/get.dart';
import 'package:sign2/app/bindings/sign_to_text_binding.dart';
import 'package:sign2/features/sign-to-text/views/sign_to_text_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.videoTranslate,
      page: () => SignToTextScreen(),
      binding: SignToTextBinding(),
    ),
  ];
}
