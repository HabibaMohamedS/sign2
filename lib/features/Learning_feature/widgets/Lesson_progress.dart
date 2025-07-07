import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class LessonProgress extends StatelessWidget {
  const LessonProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "67".tr,
            style: AppTextStyle.titles,
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView(
              children: [
                // LessonModuleCard(
                //   lesson: LessonModuleCardModel(
                //     lessonNo: 1,
                //     name: "Cairo",
                //     isCompleted: true,
                //     isLocked: false,
                //     isActive: true,
                //     description: "",
                //   ),
                // ),
                // LessonModuleCard(
                //   lesson: LessonModuleCardModel(
                //     lessonNo: 2,
                //     name: "Alexindria",
                //     isCompleted: true,
                //     isLocked: false,
                //     isActive: false,
                //     description: "",
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
