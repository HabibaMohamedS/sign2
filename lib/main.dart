import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/app/bindings/binding.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/firebase_options.dart';
import 'app/routes/app_pages.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  //runApp(SignLanguageApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            fontFamily: 'Poppins',
          ),

          initialBinding: MyBinding(),
          initialRoute:MainMenuScreen.routeName,
          getPages: AppPages.routes,
        //  home: const MainMenuScreen(),
        
        );
      },

      //const CategoryDetailsScreen(),
    );
  }
}

// class SignLanguageApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Sign Language Recognition',
//       theme: ThemeData.dark(),
//       initialRoute: AppRoutes.videoTranslate,
//       getPages: AppPages.routes,
//     );
//   }
//}


