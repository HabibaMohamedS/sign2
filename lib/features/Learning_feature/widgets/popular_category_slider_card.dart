import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class PopularCategorySliderCard extends StatelessWidget {
  final String title;
  void Function() onTap;
  PopularCategorySliderCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
        log("Card tapped");
      },

      child: SizedBox(
        height: 241.h,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(25.0.h),
                height: 154.h,
                width: 216.w,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Image.asset(
                  "assets/images/bro.png",
                  // fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),
              Text(title, style: AppTextStyle.titles),
            ],
          ),
        ),
      ),
    );
  }
}
