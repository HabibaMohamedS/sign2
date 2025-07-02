import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:sign2/features/sign-to-text/viewmodels/sign_to_text_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
class SignToTextScreen extends GetView<SignToTextController> {
  const SignToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => Scaffold(
          backgroundColor: AppColors.background,
          body: Obx(() {
            final camCtrl = controller.cameraController.value;
      
            if (camCtrl == null || !camCtrl.value.isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }
      
           final showTranslation = controller.isTranslating.value || controller.translatedText.value != null;
      
            return Stack(
              fit: StackFit.expand,
              children: [
                // Always show camera in background
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: camCtrl.value.previewSize!.height,
                    height: camCtrl.value.previewSize!.width,
                    child: CameraPreview(camCtrl),
                  ),
                ),
      
                // Flip button
                if (!showTranslation)
                  Positioned(
                    top: 40.h,
                    right: 20.w,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                        onPressed: controller.toggleCamera,
                      ),
                    ),
                  ),
      
                   // Exit camera button
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        controller.cameraController.value?.dispose();
                        Get.back();
                      },
                    ),
                  ),
                ),
      
                // Record button
                if (!showTranslation)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 60.h),
                      child: GestureDetector(
                        onTap: controller.recordToggle,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: controller.isRecording.value ? Colors.red : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black54, width: 2),
                          ),
                          child: Icon(
                            controller.isRecording.value ? Icons.stop : Icons.videocam,
                            color: controller.isRecording.value ? Colors.white : Colors.black,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
      
                // Translation overlay
                if (showTranslation)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.4,
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.isTranslating.value)
                            Column(
                              children: [
                                Text(
                                  'Translating...',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkPurple,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                CircularProgressIndicator(color: AppColors.darkNavy),
                              ],
                            )
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Translation',
                                        style: TextStyle(
                                          fontSize: 26.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkNavy,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        controller.translatedText.value ?? '',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.darkPurple,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                          
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 32.h),
                                    FloatingActionButton(
                                      heroTag: 'audio',
                                      mini: true,
                                      shape: const CircleBorder(),
                                      backgroundColor: AppColors.darkNavy,
                                      onPressed: controller.speakTranslation,
                                      child: Icon(Icons.volume_up, color: AppColors.white, size: 20.sp),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.darkNavy,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    child: DropdownButton<String>(
                                      value: controller.selectedLanguage.value,
                                      dropdownColor: AppColors.darkNavy,
                                      style: const TextStyle(color: Colors.white), // Selected text color
                                      iconEnabledColor: Colors.white,
                                      underline: const SizedBox(), // Remove underline
                                      onChanged: (v) {
                                        controller.selectedLanguage.value = v!;
                                        controller.translateToMultiLanguage();
                                      },
                                      items: controller.languages.map((lang) => DropdownMenuItem(
                                        value: lang['code'],
                                        child: Text(lang['name']!),
                                      )).toList(),
                                    ),
                                  )
                                  ],
                                ),
                              ],
                            ),
                          SizedBox(height: 150.h),
                          OutlinedButton(
                            onPressed: () {
                             controller.translatedText.value = null;
                              controller.isRecording.value = false;
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.darkNavy, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 15.h,
                              ),
                            ),
                            child: Text(
                              'Record again',
                              style: TextStyle(
                                color: AppColors.darkPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// This widget is the main screen for the sign-to-text feature, 
//displaying the camera preview and translation results.