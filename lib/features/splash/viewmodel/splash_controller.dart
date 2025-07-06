import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/onboarding/services/storage_services.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Future.delayed(const Duration(seconds: 3), () {
    //   final storage = Get.find<StorageService>();
    //   Get.log('seenOnboarding=${storage.seenOnboarding}');
    //
    //   if (storage.seenOnboarding) {
    //     Get.offAllNamed(MainMenuScreen.routeName);
    //   } else {
    //     Get.offAllNamed(AppRoutes.onboardingRoute);
    //   }
    // });
  }
}