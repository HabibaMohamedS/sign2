import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/features/onboarding/viewmodel/onboarding_controller.dart';
import 'package:sign2/support/custom_widgets/onboarding_page.dart';
import 'package:sign2/support/theme/app_images.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.backgroundImage, // Your single background image
                fit: BoxFit.cover,
              ),
            ),
            PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // — Screen 1 —
              OnboardingPage(
                text: 'Welcome to Fahm where you can be understood!',
                btn: "Let's begin!",
                showLogo: false,
                onTap: controller.next,
              ),
              // — Screen 2 —
              OnboardingPage(
                img: AppImages.onboarding1,
                text: 'Now you can translate from sign language to text, just click on the record button and get started.',
                btn: 'Next',
                onTap: controller.next,
              ),
              // — Screen 3 —
              OnboardingPage(
                img: AppImages.onboarding2,
                text: 'Use our learning section to benefit from a wide range of Arabic sign language gestures.',
                btn: 'Next',
                onTap: controller.next,
              ),
              // — Screen 4 —
              OnboardingPage(
                img: AppImages.onboarding3,
                text: 'Search for the most suitable Arabic sign language centers based on your preferences.',
                btn: 'Next',
                onTap: controller.next,
              ),
              // — Screen 5 (sign-up prompt) —
              OnboardingPage(
                text: "Let's create your account!",
                btn: 'Sign me up!',
                onTap: () =>{//Get.offAllNamed('/signin')
                },
                trailing: TextButton(
                  onPressed: controller.complete,
                  child: const Text('Skip'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}