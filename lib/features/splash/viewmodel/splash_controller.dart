import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/onboarding/services/storage_services.dart';
import 'package:sign2/support/network/network_controller.dart';

class SplashController extends GetxController {
  // Example for your splash screen's controller or initState
@override
// void onInit() {
//   super.onInit();
//   Future.delayed(const Duration(seconds: 2), () async {
//     final networkController = Get.find<NetworkController>();
//     if (!networkController.connected.value) {
//       // Show dialog or navigate to a "No Internet" screen
//       Get.dialog(
//         AlertDialog(
//           title: const Text('No Internet'),
//           content: const Text('Please connect to the internet to continue.'),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//         barrierDismissible: false,
//       );
//     } else {
//       // Proceed to main menu or onboarding
//       Get.offAllNamed(MainMenuScreen.routeName);
//     }
//   });
// }
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {
      final storage = Get.find<StorageService>();
      Get.log('seenOnboarding=${storage.seenOnboarding}');     

      if (storage.seenOnboarding) {
        Get.offAllNamed(MainMenuScreen.routeName);
      } else {
        Get.offAllNamed(AppRoutes.onboardingRoute);            
      }
    });
  }
//   @override
// void onReady() async {
//   super.onReady();
//   final networkController = Get.find<NetworkController>();

//   // Wait for the network check to complete
//   await Future.delayed(const Duration(seconds: 1));
//   await networkController.checkConnection();

//   if (!networkController.connected.value) {
//   Future.delayed(Duration.zero, () {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('No Internet'),
//         content: const Text('Please connect to the internet to continue.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//               onReady(); // Retry
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   });
//   return;
// }

//   final storage = Get.find<StorageService>();
//   if (storage.seenOnboarding) {
//     Get.offAllNamed(MainMenuScreen.routeName);
//   } else {
//     Get.offAllNamed(AppRoutes.onboardingRoute);
//   }
// }
}