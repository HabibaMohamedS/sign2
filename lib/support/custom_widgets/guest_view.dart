import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/support/theme/app_colors.dart';

class GuestProfileTab extends StatelessWidget {
  const GuestProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 96.sp, color: AppColors.darkPurple),
            SizedBox(height: 24.h),
            Text(
              'You’re not signed in',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Sign in to edit your profile, and more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.darkPurple.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 50.h),
            ElevatedButton(
              onPressed:
                  () =>
                      Get.toNamed(AppRoutes.login, arguments: {'nextTab': 2}),
              style: ElevatedButton.styleFrom(
                backgroundColor:AppColors.darkPurple,
                padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 50.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.darkNavy, fontSize: 16.sp),
                    ),
                    TextButton(
                      onPressed:() => Get.toNamed(AppRoutes.signUp, arguments: {'nextTab': 2}), 
                      child: Text(
                        "Register",
                        style: TextStyle(color: AppColors.darkNavy),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
