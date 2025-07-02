import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/view/category_details_screen.dart';
import 'package:sign2/features/Learning_feature/view/video_screen.dart';
import 'package:sign2/features/Quizzes/view_model/quiz_controller.dart';
import 'package:sign2/features/Quizzes/widgets/option_tile.dart';
import 'package:sign2/support/custom_widgets/custom_elevated_button.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class QuizDetailsScreen extends StatelessWidget {
  static const String routeName = "/quizDetailsScreen";

  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.find<QuizController>();

    final args = Get.arguments as Map<String, dynamic>;
    final String playlistId = args['playlistId'];
    final String title = args['title'];

    controller.playlistId = playlistId;
    controller.title = title;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      body: Obx(() {
        final index = controller.currentQuestionIndex.value;
        final question = controller.quizQuestions[index];
        final options = question.options;
    
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
    
              VideoScreen(
                videoId: question.videoUrl ?? '',
                height: 300.h,
                autoPlay: true,
                loop: true,
                mute: true,
                showControls: false,
                showFullscreenButton: false,
    
              ),
    
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Question ${index + 1}", style: AppTextStyle.QHeader),
                    SizedBox(height: 8.h),
                    Text(question.question, style: AppTextStyle.QBody),
                    SizedBox(height: 20.h),
                    ...List.generate(options.length, (i) {
                      return Obx(()=>OptionTile(
                        label: options[i],
                        index: i,
                        isSelected: controller.selectedOption.value == i,
                        isSubmitted: controller.isSubmitted.value,
                        isCorrect: i == question.correctAnswerIndex,
                        controller: controller,
                      )
                      );
                    }),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        buttonText: controller.isSubmitted.value
                            ? (index == controller.quizQuestions.length - 1
                            ? 'Finish'
                            : 'Next')
                            : 'Submit',
                        onPressed: () {
                          if (!controller.isSubmitted.value) {
                            controller.submitAnswer();
                          } else {
                            controller.goToNextQuestion();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                          buttonText: 'Back',
                          onPressed: (){
                            Get.toNamed(
                              CategoryDetailsScreen.routeName,
                              arguments: {
                                'playlistId': playlistId,
                                'title': title,
                              },
                            );
                          }
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
