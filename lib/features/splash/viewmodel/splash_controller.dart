import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/onboarding/services/storage_services.dart';

class SplashController extends GetxController {
  final StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    
    Get.log('seenOnboarding=${storage.seenOnboarding}');

    if (storage.seenOnboarding) {
      Get.toNamed(MainMenuScreen.routeName);
    } else {
      Get.toNamed(AppRoutes.onboardingRoute);
    }
  }
}