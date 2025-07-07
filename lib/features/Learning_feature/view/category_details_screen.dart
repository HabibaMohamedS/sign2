import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/model/data_sources/firebase_data_source.dart';
import 'package:sign2/features/Learning_feature/view/lesson_detail_screen.dart';
import 'package:sign2/features/Learning_feature/view_model/lessons_state_management.dart';
import 'package:sign2/features/Learning_feature/widgets/lesson_description.dart';
import 'package:sign2/features/Learning_feature/widgets/lesson_module_card.dart';
import 'package:sign2/support/custom_widgets/custom_app_bar.dart';
import 'package:sign2/support/theme/app_text_styles.dart';


import '../../Quizzes/view/quiz_detsails_screen.dart';
import '../../Quizzes/view_model/quiz_controller.dart';

class CategoryDetailsScreen extends StatefulWidget {
  static const String routeName = "/categoryDetailsScreen";

  const CategoryDetailsScreen({
    super.key,
    // required this.playlistId,
    // this.title,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  // final String playlistId;
  //final LessonsStateManagement lessonsStateManagement = Get.find<LessonsStateManagement>(); saraa

  //final playlistId = "";
  // int lessonIndex = 0;
 

  // void initState() {

  //   lessonsStateManagement.fetchLessonData(Get.arguments['playlistId'] ?? "");
  // }

  late LessonsStateManagement lessonsStateManagement;
  final FirebaseDataSource dataSource = FirebaseDataSource();

  @override
  // void initState() {
  //   super.initState();
  //   lessonsStateManagement = Get.find<LessonsStateManagement>();
  //   lessonsStateManagement.fetchLessonData(Get.arguments['playlistId'] ?? "");
  // }

  void initState() {
    super.initState();
    lessonsStateManagement = Get.find<LessonsStateManagement>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    lessonsStateManagement.fetchLessonData(args['playlistId'] ?? '');
  }

  void _startQuiz() async {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final playlistId = args['playlistId'] as String? ?? '';
    final title = args['title'] as String? ?? '';
    if (playlistId.isEmpty) return;

    final allLessons = await dataSource.fetchLessons(playlistId);
    allLessons.shuffle();

    final quizLessons =
        allLessons.length > 10 ? allLessons.take(10).toList() : allLessons;

    final quizController = Get.put(QuizController());
    quizController.generateQuiz(quizLessons);

    Get.toNamed(QuizDetailsScreen.routeName,  arguments: {
      'playlistId': playlistId,
      'title': title,
    },);
  }

  @override
  Widget build(BuildContext context) {
    final String playlistId = Get.arguments['playlistId'] ?? "";
     final String? title = Get.arguments['title'] ?? "";
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CustomAppBar(),
                CustomAppBar(onStartQuiz: _startQuiz),
                LessonDescription(
                    title: title,
                    lessonCount: lessonsStateManagement.lessons.length),
                Padding(
                  padding: EdgeInsets.all(20.0.sp),
                  child: Text("67".tr, style: AppTextStyle.titles),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: lessonsStateManagement.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : lessonsStateManagement.lessons.isEmpty
                          ? const Center(child: Text("No lessons available."))
                          : ListView.builder(
                              itemCount: lessonsStateManagement.lessons.length,
                              itemBuilder: (context, index) {
                                final lesson =
                                    lessonsStateManagement.lessons[index];
                                return LessonModuleCard(
                                  lesson: LessonModuleCardModel(
                                    lessonNo: index + 1,
                                    name: lesson.title ?? "Untitled",
                                    isCompleted: false,
                                    isLocked: false,
                                    isActive: index ==
                                        lessonsStateManagement
                                            .lessonIndex.value, // Customize this
                                    description: "", // Add real data if needed
                                  ),
                                  onPressed: () {
                                    // lessonsStateManagement
                                    //     .updateLessonIndex(index);
                                    log(" pressed Lesson index: $index");
                                    lessonsStateManagement
                                        .updateLessonIndex(index);
                                    Get.toNamed(
                                      LessonDetailScreen.routeName,
                                      arguments: {
                                        'lessonIndex': index,
                                        'playlistId': playlistId,
                                        'title': title,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
