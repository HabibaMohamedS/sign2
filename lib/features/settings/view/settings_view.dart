import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark=false;
    return Column(
      spacing: 10.h,
      children: [
        SizedBox(height: 50.h,),
        SwitchListTile.adaptive(
          inactiveThumbColor:  Theme.of(context).colorScheme.secondary,
          trackOutlineColor:  WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
          activeTrackColor: Theme.of(context).colorScheme.secondary,
          value:isDark,
          onChanged: (value) {
          },
          title: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.darkPurple,
              ),
            
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.all(12.0.w),
                  child: Text(
                    isDark ? "Dark Mode" : "Light Mode",
                    softWrap: true,
                    style:  TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.language,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Padding(
            padding: EdgeInsets.all(8.0.w),
            child:  Text("language",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp)),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(15),
              iconEnabledColor:AppColors.darkPurple,
              items: const [
                DropdownMenuItem(
                  value: "en",
                  child: Text(
                    "English",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: "ar",
                  child:
                      Text("عربى", style: TextStyle(color: Colors.white)),
                )
              ],
              onChanged: (value) {
                if(value!=null) {
                //  TO:do
                }
              },
              dropdownColor: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
          ),
        )
      ],
    );
  }
}