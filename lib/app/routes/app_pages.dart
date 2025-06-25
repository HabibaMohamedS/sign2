import 'package:get/get.dart';
import 'package:sign2/app/bindings/binding.dart';
import 'package:sign2/app/bindings/sign_to_text_binding.dart';
import 'package:sign2/features/Learning_feature/view/category_details_screen.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Learning_feature/view/lesson_detail_screen.dart';
import 'package:sign2/features/Quizzes/view/grade_screen.dart';
import 'package:sign2/features/Quizzes/view/quiz_detsails_screen.dart';
import 'package:sign2/features/Recommendation%20System/view/learning_centers.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/sign-to-text/views/sign_to_text_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.videoTranslate,
      page: () => SignToTextScreen(),
      binding: SignToTextBinding(),
    ),
    GetPage(
      name: '/mainMenu',
      page: () => const MainMenuScreen(),
    ),
    GetPage(
      name: LearnSlScreen.routeName,
      page: () => LearnSlScreen.learnSLScreen(),
    ),
    GetPage(
        name: CategoryDetailsScreen.routeName,
        page: () => CategoryDetailsScreen(),
        binding: MyBinding()),
    GetPage(
      name: LessonDetailScreen.routeName,
      page: () => LessonDetailScreen(),
      binding: MyBinding(), // Assuming you have a binding class for this screen
    ),
    GetPage(name: QuizDetailsScreen.routeName, page: () => QuizDetailsScreen()),
    GetPage(name: GradeScreen.routeName, page: () => const GradeScreen()),
    GetPage(name: LearningCenters.routeName, page: () => const LearningCenters()),
    //GetPage(name: VideoScreen.routeName, page: () =>  VideoScreen())
  ];
}
