 import 'package:get/get.dart';
import 'dart:math';

import '../../Learning_feature/model/models/lesson_model.dart';
import '../model/quiz_model.dart';
import '../view/grade_screen.dart';

class QuizController extends GetxController {
  RxList<QuizQuestion> quizQuestions = <QuizQuestion>[].obs;
  RxInt selectedOption = (-1).obs;
  RxInt currentQuestionIndex = 0.obs;
  RxBool isSubmitted = false.obs;
  RxInt correctAnswersCount = 0.obs;
  RxInt incorrectAnswersCount = 0.obs;


  List<LessonModel> allLessons = [];

  Future<void> generateQuiz(List<LessonModel> lessons) async {
    allLessons = lessons;

    final random = Random();
    final questions = <QuizQuestion>[];

    for (var lesson in lessons) {
      final correctTitle = lesson.title ?? "Unknown";

      // Get other random titles (wrong answers)
      final otherLessons = List<LessonModel>.from(lessons)
        ..remove(lesson);

      otherLessons.shuffle();
      final wrongTitles = otherLessons
          .take(3)
          .map((e) => e.title ?? "Wrong Option")
          .toList();

      // Combine correct + wrong titles
      final allOptions = [...wrongTitles, correctTitle]..shuffle();

      final correctIndex = allOptions.indexOf(correctTitle);

      questions.add(QuizQuestion(
        question: "What is the correct title for this video?",
        options: allOptions,
        correctAnswerIndex: correctIndex,
        videoUrl: lesson.videoId ?? "",
        //  videoUrl: "https://www.youtube.com/watch?v=2vaIeTRA0iw"

      ));
    }

    quizQuestions.value = questions;
  }

  void selectOption(int index) {
    selectedOption.value = index;
  }

  bool isAnswerCorrect() {
    return selectedOption.value ==
        quizQuestions[currentQuestionIndex.value].correctAnswerIndex;
  }

  void submitAnswer() {
    if (selectedOption.value == -1) return; // Prevent submitting if nothing selected
    if (isAnswerCorrect()) {
      correctAnswersCount++;
    } else {
      incorrectAnswersCount++;
    }
    isSubmitted.value = true;
  }

  void goToNextQuestion() {
    if (currentQuestionIndex.value < quizQuestions.length - 1) {
      currentQuestionIndex.value++;
      selectedOption.value = -1;
      isSubmitted.value = false;
    }else{
      // End of quiz → Navigate to GradeScreen
      Get.offNamed(
        GradeScreen.routeName,
        arguments: {
          'correct': correctAnswersCount.value,
          'incorrect': incorrectAnswersCount.value,
        },
      );
    }
  }

  String get currentVideoId {
    final index = currentQuestionIndex.value;
    return allLessons[index].videoId ?? '';
  }

}
