import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_images.dart';

class OnboardingPage extends StatelessWidget {
  final String? img;
  final String text;
  final String btn;
  final bool showLogo;
  final VoidCallback? onTap;
  final Widget? trailing; // Changed from leading to trailing for better semantics
  
  const OnboardingPage({
    this.img,
    required this.text,
    required this.btn,
    this.showLogo = true,
    this.onTap,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showLogo)
                SizedBox(
                      width: 120.w,  // Adjust as needed
                      height: 120.h,
                      child: Image.asset(
                        AppImages.logo,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    SizedBox(width: 120.w),
              
              trailing ?? SizedBox(width: 55.w),
            ],
          ),
          const Spacer(),
          if (img != null) Image.asset(img!, height: 250.h),
          if (img != null) SizedBox(height: 24.h),
          SizedBox(height: 24.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkPurple,
              fontSize: 20.sp, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPurple,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: onTap, 
            child: Text(
              btn,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}