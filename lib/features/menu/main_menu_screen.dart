import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Recommendation%20System/view/learning_centers.dart';
import 'package:sign2/features/menu/widgets/circular_menu_item.dart';
import 'package:sign2/support/theme/app_images.dart';
import 'package:sign2/support/theme/app_text_styles.dart';
import '../../support/theme/app_colors.dart';

class MainMenuScreen extends StatefulWidget {
  static const String routeName = "/mainMenu";
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar:
              true, // Optional, if you want the image under the AppBar too
          appBar: AppBar(
            title: Image.asset(AppImages.logo),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 35.sp,
                  color: AppColors.darkPurple,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: Stack(children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.backgroundImage, // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 70.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: Text(
                        'Hi 🌟 \n Omar!',
                        softWrap: true,
                        style: AppTextStyle.titles.copyWith(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 65.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularMenuItem(
                              imagePath: AppImages.translateLogo,
                              title: "Translate to Text",
                              onTap: () => Get.toNamed(AppRoutes.videoTranslate),
                            ),
                            SizedBox(height: 170.h),
                            CircularMenuItem(
                              imagePath: AppImages.discoverPlacesLogo,
                              title: "Discover Places",
                              onTap: () => Get.toNamed(LearningCenters.routeName)
                             ,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularMenuItem(
                              imagePath: AppImages.learnSignLogo,
                              title: "Learn Sign Language",
                              onTap: () => Get.toNamed(LearnSlScreen.routeName),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h), // Add some bottom padding
                  ],
                ),
              ),
            ),
          ]),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(11, 183, 140, 240), // Adjust opacity
                  blurRadius: 50, // Very blurred shadow
                  spreadRadius: 0,
                  offset: Offset(0, -6), // Soft upward shadow
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: CurvedNavigationBar(
                  height: 75.h,
                  index: _selectedIndex,
                  // color: Color.fromARGB(172, 183, 140, 240),
                  color: const Color.fromARGB(63, 255, 255, 255),
                  // color:Color.fromARGB(73, 203, 169, 248),
                  //buttonBackgroundColor:  Color.fromARGB(157, 141, 73, 230),
                  buttonBackgroundColor: AppColors.darkPurple,
                  backgroundColor: Colors.transparent,
                  animationDuration: const Duration(milliseconds: 450),
                  onTap: (index) async {
                    // 1.  Move the bubble immediately
                  setState(() => _selectedIndex = index);

                  // 2.  Push pages based on index
                  if (index == 2) {                     // profile
                    await Get.toNamed(AppRoutes.profile);
                    // 3.  When you return (user presses back), reset to home
                    setState(() => _selectedIndex = 1); // 1 = home
                  } else if (index == 0) {              // settings
                    //await Get.toNamed(AppRoutes.settings);
                    setState(() => _selectedIndex = 1);
                  }
                  },
                  items: List.generate(3, (index) {
                    List<IconData> icons = [
                      Icons.settings,
                      Icons.home,
                      Icons.person
                    ];
                    final isSelected = _selectedIndex == index;
      
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[index],
                          size: isSelected ? 40 : 30,
                          color: isSelected ? Colors.white : AppColors.orange,
                        ),
                      ],
                    );
                  })),
            ),
          )),
    );
  }
}
