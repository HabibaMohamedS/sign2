import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Quizzes/view_model/quiz_controller.dart';
import 'package:sign2/features/Quizzes/widgets/option_tile.dart';
import 'package:sign2/support/custom_widgets/custom_elevated_button.dart';
import 'package:sign2/support/theme/app_text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizDetailsScreen extends StatefulWidget {
  static const String routeName = "/quizDetailsScreen";

  const QuizDetailsScreen({super.key});

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  final QuizController controller = Get.find<QuizController>();
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();

    final firstVideoId = controller.quizQuestions.isNotEmpty
        ? controller.quizQuestions[0].videoUrl ?? ''
        : '';

    _youtubeController = YoutubePlayerController(
      initialVideoId: firstVideoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    // Update video when current question index changes
    controller.currentQuestionIndex.listen((index) {
      final videoId = controller.quizQuestions[index].videoUrl ?? '';
      _youtubeController.load(videoId);
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                  child: YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.deepPurple,
                      handleColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
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
                      return OptionTile(
                        label: options[i],
                        index: i,
                        isSelected: controller.selectedOption.value == i,
                        isSubmitted: controller.isSubmitted.value,
                        isCorrect: i == question.correctAnswerIndex,
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


