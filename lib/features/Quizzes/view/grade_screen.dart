import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Quizzes/view_model/grade_controller.dart';

import '../../../support/custom_widgets/custom_elevated_button.dart';
import '../../../support/theme/app_colors.dart';
import '../../../support/theme/app_text_styles.dart';

class GradeScreen extends StatelessWidget {
  static const String routeName = "/gradeScreen";
  const GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, int>;
    final GradeController controller = Get.put(
      GradeController(
        correctAnswers: args['correct'] ?? 0,
        incorrectAnswers: args['incorrect'] ?? 0,
      ), // will get them from the quiz controller
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),

              Center(
                child: Text(
                  'Good Job!',
                  style: AppTextStyle.heading.copyWith(
                    color: AppColors.darkPurple,
                    fontSize: 18.sp
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                width: 400.h,
                height: 350.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.transparent),
                ),
                child: Stack(
                  children: [
                       Image.asset(
                        'assets/images/Trophy.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'You got +${controller.totalPoints} quiz points!',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.QHeader,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              Text(
                'Correct answers',
                style: AppTextStyle.QBody.copyWith(color: AppColors.darkPurple),
              ),
              Text(
                '${controller.correctAnswers} questions',
                style: AppTextStyle.QBody.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.h),

              Text(
                'Incorrect answers',
                style: AppTextStyle.QBody.copyWith(color: AppColors.darkPurple),
              ),
              Text(
                '${controller.incorrectAnswers} questions',
                style: AppTextStyle.QBody.copyWith(fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              CustomElevatedButton(
                buttonText: 'Next',
                onPressed: () {
                  Get.offAllNamed(
                    LearnSlScreen.routeName,
                  );
                },
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
