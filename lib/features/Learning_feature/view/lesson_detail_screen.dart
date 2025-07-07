import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/model/models/lesson_model.dart';
import 'package:sign2/features/Learning_feature/view/video_screen.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/support/custom_widgets/custom_elevated_button.dart';
import 'package:sign2/support/custom_widgets/framed_custom_btn.dart';
import 'package:sign2/support/theme/app_colors.dart';


class LessonDetailScreen extends StatefulWidget {
  static const String routeName = "/lessonDetailScreen";

  const LessonDetailScreen({super.key});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final LessonsStateManagement lessonController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true, // Allows body to extend under AppBar
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.darkNavy, // Makes AppBar transparent
        elevation: 0, // Removes shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white), // Back button
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          "65".trParams({
            "number": "${lessonController.lessonIndex.value + 1}",
          }),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )),
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(MainMenuScreen.routeName),
              icon: const Icon(Icons.home, color: Colors.white)),
        ],
      ),
      body: Obx(() {
        if (lessonController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final int lessonIndex = lessonController.lessonIndex.value;
        final lessons = lessonController.lessons;

        if (lessonIndex < 0 || lessonIndex >= lessons.length) {
          return Center(child: Text("Invalid lesson index: $lessonIndex"));
        }

        final lesson = lessons[lessonIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VideoScreen(
                key: ValueKey(
                    lesson.videoId), // This forces rebuild when videoId changes
                videoId: lesson.videoId ?? 'dQw4w9WgXcQ',
              ),
            ),
            _buildLessonDetails(lesson),
            _buildNavigationButtons(lessonIndex),
          ],
        );
      }),
    );
  }

  // ... rest of your existing _buildAppBar, _buildLessonDetails,
  // and _buildNavigationButtons methods remain the same ...

  Widget _buildAppBar(int lessonIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          Text(
            "65".trParams({
              "number": "${lessonIndex + 1}",
            }),
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48), // For balance
        ],
      ),
    );
  }

  Widget _buildLessonDetails(LessonModel lesson) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.title ?? "No Title",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          // Text(
          //   lesson.thumbnail ?? "No description available",
          //   style: TextStyle(fontSize: 14.sp),
          // ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(int currentIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FramedCustomButton(
            onPressed: currentIndex > 0
                ? () => lessonController.updateLessonIndex(currentIndex - 1)
                : () => Get.back(),
            buttonText: '53'.tr,
          ),
          CustomElevatedButton(
            onPressed: currentIndex < lessonController.lessons.length - 1
                ? () => lessonController.updateLessonIndex(currentIndex + 1)
                : () => Get.back(),
            buttonText: "54".tr,
          ),
        ],
      ),
    );
  }
}
