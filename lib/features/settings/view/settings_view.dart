import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<ThemeProvider>(context);
    bool isDark=false;
    return Column(
      spacing: 10.h,
      children: [
        SwitchListTile.adaptive(
          inactiveThumbColor:  Theme.of(context).colorScheme.secondary,
          trackOutlineColor:  WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
          activeTrackColor: Theme.of(context).colorScheme.secondary,
          value:isDark,
          onChanged: (value) {
            // provider
            //     .changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          },
          //   inactiveTrackColor:Theme.of(context).primaryColor,,
          title: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
                //color: Theme.of(context).iconTheme.color,
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
             // value: provider.language,
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
// }import 'package:flutter/material.dart';

// import 'package:islamy_application/providers/theme_provider.dart';
// import 'package:provider/provider.dart';

// class SettingsSideBar extends StatefulWidget {
//   const SettingsSideBar({super.key});

//   @override
//   State<SettingsSideBar> createState() => _SettingsSideBarState();
// }

// class _SettingsSideBarState extends State<SettingsSideBar> {
//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<ThemeProvider>(context);
//     return Drawer(
//       shadowColor: Theme.of(context).primaryColor.withOpacity(0.25),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       width: MediaQuery.of(context).size.width * 0.79,
//       child: ListView(
//         children: [
//           DrawerHeader(
//             padding: EdgeInsets.zero,
//             decoration: BoxDecoration(
//                 //  border: Border(top: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.20),width: 10)),
//                 gradient: LinearGradient(
//               begin: FractionalOffset.topCenter,
//               end: FractionalOffset.bottomCenter,
//               colors: [
//                 Theme.of(context).primaryColor.withOpacity(0.20),
//                 Theme.of(context).primaryColor,
//               ],
//             )),
//             child: Image.asset(
//               "assets/images/sideBar_image.png",
//               alignment: Alignment.bottomCenter,
//             ),
//           ),
//           SwitchListTile.adaptive(
//             inactiveThumbColor:  Theme.of(context).colorScheme.secondary,
//             trackOutlineColor:  WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
//             activeTrackColor: Theme.of(context).colorScheme.secondary,
//             value: provider.isDark,
//             onChanged: (value) {
//               provider
//                   .changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
//             },
//             //   inactiveTrackColor:Theme.of(context).primaryColor,,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Icon(
//                   provider.isDark ? Icons.dark_mode : Icons.light_mode,
//                   color: Theme.of(context).iconTheme.color,
//                 ),
              
//                 Expanded(
//                   child: Text(
//                     provider.isDark ? "Dark Mode" : "Light Mode",
//                     softWrap: true,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w500, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.language,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             title: const Text("language",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
//             trailing: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(15)),
//               child: DropdownButton<String>(
//                 borderRadius: BorderRadius.circular(15),
//                 iconEnabledColor:Provider.of<ThemeProvider>(context).isDark? Theme.of(context).colorScheme.secondary: Theme.of(context).colorScheme.surface,
//                 value: provider.language,
//                 items: const [
//                   DropdownMenuItem(
//                     value: "en",
                
//                     child: Text(
//                       "English",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   DropdownMenuItem(
//                     value: "ar",
//                     child:
//                         Text("عربى", style: TextStyle(color: Colors.white)),
//                   )
//                 ],
//                 onChanged: (value) {
//                   if(value!=null) {
//                     provider.changeLanguage(value);
//                   }
//                 },
//                 dropdownColor: Theme.of(context).primaryColor.withOpacity(0.4),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }