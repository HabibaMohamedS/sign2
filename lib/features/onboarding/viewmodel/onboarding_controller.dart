import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/onboarding/services/storage_services.dart';

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;
  late final PageController pageController;
  final storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void next() {
    if (pageIndex.value < 4) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void onPageChanged(int i) => pageIndex.value = i;

  void complete() {
    storage.seenOnboarding = true;
    Get.offAllNamed(MainMenuScreen.routeName);
  }
}
