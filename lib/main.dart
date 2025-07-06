import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sign2/app/bindings/binding.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/onboarding/services/storage_services.dart';
import 'package:sign2/firebase_options.dart';
import 'app/routes/app_pages.dart';

///TODO: if the user is signed in add his name to the screen s
///TODO MAke sure all are responsive
///TODO check if the user is connected to the network before navigating to features
/// TODO check if it is the first time a user accessed the app before the onboarding
///TODO Add a back button in the quiz screen and show a dialoge asking the user if he is sure as it  would remove his progress

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(StorageService(), permanent: true);
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
        // final storage = Get.find<StorageService>();
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            fontFamily: 'Poppins',
          ),

          initialBinding: MyBinding(),
          initialRoute: '/welcome',
          getPages: AppPages.routes,
          // onInit: () {
          //   if (storage.seenOnboarding) {
          //     Get.offAllNamed(MainMenuScreen.routeName);
          //   }
          // },
        //  home: const MainMenuScreen(),
        
        );
      },
    );
  }
}


