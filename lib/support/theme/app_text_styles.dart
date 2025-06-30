import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:sign2/support/theme/app_colors.dart';

class AppTextStyle{
  static  TextStyle heading = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );
  static TextStyle textFieldLabel = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  static TextStyle buttonLabel = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.buttonTextColor,
  );
  static TextStyle titles=TextStyle(
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: AppColors.darkNavy,
  );
  static  TextStyle menuItemText = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: AppColors.darkNavy,
  );
  static  TextStyle caption = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color:AppColors.darkNavy,
    fontFamily: 'Poppins',
    height: 2,
    wordSpacing: 1.5,
  );

  static  TextStyle bodyText = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.buttonTextColor,
    fontFamily: 'Poppins',
    height: 1.5
  );

  static  TextStyle buttonText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: Colors.white,
  );

  static TextStyle QHeader = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.darkNavy,
  );

  static TextStyle QBody = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: AppColors.darkNavy,
  );
}