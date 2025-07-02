import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/features/Learning_feature/view/learn_sl_screen.dart';
import 'package:sign2/features/Recommendation%20System/view/learning_centers.dart';
import 'package:sign2/features/menu/widgets/circular_menu_item.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_images.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 20.w,),
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
                      onTap: () => Get.toNamed(LearningCenters.routeName),
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
    );
  }
}
