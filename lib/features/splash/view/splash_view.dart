import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sign2/features/splash/viewmodel/splash_controller.dart';
import 'package:sign2/support/theme/app_images.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      body: Center(child: Image.asset(AppImages.splash)),
    );
  }
}