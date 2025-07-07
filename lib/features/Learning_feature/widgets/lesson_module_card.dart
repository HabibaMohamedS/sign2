import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_images.dart';

class LessonModuleCard extends StatelessWidget {
  final LessonModuleCardModel lesson;
  void Function()? onPressed;
  LessonModuleCard({super.key, required this.lesson, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              // padding: EdgeInsets.only(top:10.h),
              child: Column(spacing: 5.h, children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.sp),
                  child: SizedBox(
                    height: 52.sp,
                    width: 52
                        .sp, // Ensure it's a circle by setting both height and width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lesson.isActive
                            ? AppColors.darkNavy
                            : AppColors.lightOrange,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero, // No internal padding
                      ),
                      onPressed: onPressed,
                      child: Icon(
                        lesson.isActive
                            ? Icons.play_arrow_rounded
                            : Icons.play_arrow_outlined,
                        size: 24.sp,
                        color: lesson.isActive
                            ? AppColors.orange
                            : AppColors.darkNavy,
                      ),
                    ),
                  ),
                ),
                Image.asset(AppImages.line),
              ]),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(30.h),
              //height: 161.h,
              width: 246.w,
              decoration: BoxDecoration(
                  color: lesson.isActive
                      ? AppColors.darkNavy
                      : AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(32.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.h,
                children: [
                  Text(
                    "65".trParams({
                      "number": lesson.lessonNo.toString(),
                    }),
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: lesson.isActive
                            ? const Color.fromARGB(221, 255, 255, 255)
                            : AppColors.darkNavy),
                  ),
                  Text(lesson.name,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: lesson.isActive
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : AppColors.darkNavy),
                      softWrap: true, // Ensures the text wraps
                      overflow: TextOverflow.visible),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class LessonModuleCardModel {
  final int lessonNo;
  final String name;
  // final String imagePath;
  // final int lessonCount;
  // Color iconColor;
  // Color iconBorder;
  // Color iconBackground;
  bool isCompleted;
  bool isLocked;
  bool isActive;
  String description;
  //IconData icon;
  LessonModuleCardModel({
    required this.lessonNo,
    required this.name,
    // required this.imagePath,
    // required this.lessonCount,
    // required this.iconColor,
    // required this.iconBorder,
    // required this.iconBackground,
    required this.isCompleted,
    required this.isLocked,
    required this.isActive,
    required this.description,
    // required this.icon,
  });
}
