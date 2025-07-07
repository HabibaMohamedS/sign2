import 'package:get/get.dart';
import 'package:sign2/app/bindings/binding.dart';
import 'package:sign2/app/bindings/sign_to_text_binding.dart';
import 'package:sign2/features/Auth/view/login_screen.dart';
import 'package:sign2/features/Learning_feature/view/category_details_screen.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Learning_feature/view/lesson_detail_screen.dart';
import 'package:sign2/features/Quizzes/view/grade_screen.dart';
import 'package:sign2/features/Quizzes/view/quiz_detsails_screen.dart';
import 'package:sign2/features/Recommendation%20System/view/learning_centers.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/features/onboarding/view/onboarding_view.dart';
import 'package:sign2/features/profile/view/profile_view.dart';
import 'package:sign2/features/sign-to-text/views/sign_to_text_view.dart';
import 'package:sign2/features/splash/view/splash_view.dart';
import 'package:sign2/features/auth/view/sign_up_screen.dart';
import 'package:sign2/features/auth/view/welcome_screen.dart';
import 'package:sign2/services/auth_gaurd.dart';
import '../../test/firebase_test_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
    GetPage(
      name: AppRoutes.onboardingRoute,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpStep1(),
      binding: MyBinding(),
    ),
    GetPage(
      name: AppRoutes.videoTranslate,
      page: () => SignToTextScreen(),
      binding: SignToTextBinding(),
    ),
    GetPage(name: MainMenuScreen.routeName, page: () => const MainMenuScreen()),
    GetPage(name: LearnSlScreen.routeName, page: () => LearnSlScreen()),
    GetPage(name: '/firebaseTest', page: () => const FirebaseTestScreen()),
    
    GetPage(
      name: CategoryDetailsScreen.routeName,
      page: () => CategoryDetailsScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: LessonDetailScreen.routeName,
      page: () => LessonDetailScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: QuizDetailsScreen.routeName, 
      page: () => QuizDetailsScreen(),
    ),
    GetPage(
      name: GradeScreen.routeName, 
      page: () => const GradeScreen(),
    ),

    GetPage(
      name: LearningCenters.routeName,
      page: () => const LearningCenters(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: MyBinding(),
      middlewares:[AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: MyBinding(),
    ),
  ];
}
