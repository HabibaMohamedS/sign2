import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onStartQuiz;

  const CustomAppBar({super.key, required this.onStartQuiz});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
            child: Center(
              child: SizedBox(
                height: 200.h,
                width: 300.w,
                child: Image.asset("assets/images/bro.png", fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 40,
            child: ElevatedButton(
              onPressed: onStartQuiz,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                backgroundColor: AppColors.darkNavy,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 35.w),
              ),
              child: Text("Start Quiz", style: AppTextStyle.buttonLabel),
            ),
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 15.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.only(left: 5.w),
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.sp,
                  grade: 25,
                  weight: 800,
                ),
                onPressed: () {
                  Get.offAndToNamed(LearnSlScreen.routeName);
                },
              ),
            ),
          ),
        ]),
      ],
    );
  }
}