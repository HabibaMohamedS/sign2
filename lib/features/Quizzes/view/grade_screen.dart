import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Quizzes/view_model/grade_controller.dart';
import 'package:sign2/features/Quizzes/view_model/quiz_controller.dart';
import 'package:sign2/support/custom_widgets/framed_custom_btn.dart';
import '../../../support/custom_widgets/custom_elevated_button.dart';
import '../../../support/theme/app_colors.dart';
import '../../../support/theme/app_text_styles.dart';

class GradeScreen extends StatelessWidget {
  static const String routeName = "/gradeScreen";

  const GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final correct = args['correct'] ?? 0;
    final incorrect = args['incorrect'] ?? 0;
    final playlistId = args['playlistId'] ?? '';
    final title = args['title'] ?? '';

    final GradeController controller = Get.put(
      GradeController(correctAnswers: correct, incorrectAnswers: incorrect),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      body: Padding(
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
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 400.h,
              height: 350.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
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
            Text('Correct answers',
                style: AppTextStyle.QBody.copyWith(color: AppColors.darkPurple)),
            Text('$correct questions',
                style: AppTextStyle.QBody.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            Text('Incorrect answers',
                style: AppTextStyle.QBody.copyWith(color: AppColors.darkPurple)),
            Text('$incorrect questions',
                style: AppTextStyle.QBody.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FramedCustomButton(
                  buttonText: 'Retake',
                  onPressed: () async {
                    final quizController = Get.find<QuizController>();
                    quizController.resetQuiz();
                    await quizController.generateQuizFromPlaylist(
                      playlistId: playlistId,
                      title: title,
                    );
                  },
                ),
                CustomElevatedButton(
                  buttonText: 'Done',
                  onPressed: () {
                    Get.offAllNamed(LearnSlScreen.routeName);
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}


