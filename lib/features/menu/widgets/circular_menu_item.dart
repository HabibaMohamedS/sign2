import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_text_styles.dart';

class CircularMenuItem extends StatelessWidget {
  final String imagePath;
  final String title;
  void Function()? onTap;
  CircularMenuItem(
      {super.key, required this.imagePath, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SizedBox(
          height: 200.h,
          child: InkWell(
            onTap: onTap,
            child: Column(
              ///TODO:Make sure that what ever the screen size is, the menu items are always circles
              //mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 130.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(61.r),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
            
                ),
                SizedBox(
                  //height: 56.h,
                  width: 128.w,
                  child: Text( title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.menuItemText
                    ),
            
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
