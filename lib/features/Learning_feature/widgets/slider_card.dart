import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_text_styles.dart';


class SliderCard extends StatelessWidget {
  final String cardContent;
  final String categoryName;
  void Function() onTap;
  SliderCard({super.key, required this.cardContent, required this.categoryName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            height: 306.h,
            width: 290.w,
            decoration: BoxDecoration(
              color:AppColors.darkNavy,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 15.h,
              children: [
          //       Container(
          //   height: 76.h,
          //   //TODO: make this dynamic
          //   width: 104.w,
          //  // padding: EdgeInsets.symmetric(horizontal: 25.w),
          //   decoration: BoxDecoration(
          //     color: AppColors.lightOrange,
          //     borderRadius: BorderRadius.circular(32),
          //   ),
          //   child: Center(
          //     child: Text( categoryName,
          //       style: AppTextStyle.titles.copyWith(
          //         fontSize: 20.sp,
          //         fontWeight: FontWeight.bold,
          //         color: AppColors.darkNavy,
          //       ),
          //     ),
          //   ),
          // ),
                Container(
                  height: 86.h,//76.h
                  width: 124.w,//104.w
                  decoration: BoxDecoration(
                    color: AppColors.lightOrange,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Allow up to 2 lines
                        overflow: TextOverflow.ellipsis, // Add "..." if too long
                        softWrap: true,
                        style: AppTextStyle.titles.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkNavy,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                Text(
            cardContent,
            style: AppTextStyle.bodyText,
          ),],
            ),
          ),

        ],
      
      ),
    );
  }
}