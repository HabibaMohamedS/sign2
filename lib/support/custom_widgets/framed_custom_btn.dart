import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class FramedCustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FramedCustomButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      child: OutlinedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          side: BorderSide(color: AppColors.darkPurple, width: 2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child:  Text(
            buttonText,
            style: AppTextStyle.buttonLabel.copyWith( color: AppColors.darkPurple)
        ),
      ),
    );
  }
}
