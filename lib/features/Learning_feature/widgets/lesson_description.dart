import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';


class LessonDescription extends StatelessWidget {
  final String? title;
  final int lessonCount;
  const LessonDescription({super.key, this.title, required this.lessonCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:  25.w),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 1.5.h,
            children: [
              ImageIcon(const AssetImage("assets/images/icon-pie-chart.png"),
                  color: AppColors.orange),
              Text("${lessonCount} Lessons",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack)),
            ],
          ),
          Text(title??"", style: AppTextStyle.titles,),
          // SizedBox(
          //   height: 1.h,
          // ),
          Text(
            "Learn How to fingerspell ${title} in Arabic sign language.",
            style: AppTextStyle.bodyText.copyWith(
              color: AppColors.darkNavy,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              height:2
            ),

            
          ),
        ],
      ),
    );
  }
}
