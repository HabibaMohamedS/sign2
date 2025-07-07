import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';
import 'package:sign2/features/menu/home_view.dart';
import 'package:sign2/features/profile/view/profile_view.dart';
import 'package:sign2/features/settings/view/settings_view.dart';
import 'package:sign2/services/storage_services.dart';
import 'package:sign2/support/custom_widgets/guest_view.dart';
import 'package:sign2/support/theme/app_images.dart';
import '../../support/theme/app_colors.dart';

class MainMenuScreen extends StatefulWidget {
  static const String routeName = "/mainMenu";

  final int startIndex;
  final UserModel? user;

  const MainMenuScreen({
    super.key,
    this.user,
    this.startIndex = 1,            
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late int _selectedIndex;
  final _storage = StorageService();   

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    final fixedTabs = [
    const SettingsView(),
    HomeView(user: _storage.cachedUser),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(AppImages.logo),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 35.sp, color: AppColors.darkPurple),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        //Rebuild only when login state changes
        final profileTab = _storage.isLoggedIn 
            ? const ProfileView()
            : const GuestProfileTab();

        final tabs = [...fixedTabs, profileTab];

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppImages.backgroundImage, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.h, left: 20.w, right: 20.w),
              child: IndexedStack(index: _selectedIndex, children: tabs),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(11, 183, 140, 240),
              blurRadius: 50,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: CurvedNavigationBar(
            height: 70,
            index: _selectedIndex,
            color: const Color.fromARGB(63, 255, 255, 255),
            buttonBackgroundColor: AppColors.darkPurple,
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 450),
            onTap: (i) => setState(() => _selectedIndex = i),
            items: List.generate(3, (index) {
              final icons = [Icons.settings, Icons.home, Icons.person];
              final isSelected = _selectedIndex == index;
              return Icon(
                icons[index],
                size: isSelected ? 40 : 30,
                color: isSelected ? Colors.white : AppColors.orange,
              );
            }),
          ),
        ),
      ),
    );
  }
}
