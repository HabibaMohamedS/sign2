import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sign2/features/profile/viewmodel/profile_controller.dart';
import 'package:sign2/support/custom_widgets/custom_textfield.dart';
import 'package:sign2/support/theme/app_colors.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;          

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.h),
            //Username
            CustomTextField(
              label: 'Username',
              initialValue: c.username.value,
              onChanged: (v) => c.username.value = v,
            ),
            SizedBox(height: 12.h),

            //Email (read‑only)
            CustomTextField(
              label: 'Email',
              initialValue: c.email,
              readOnly: true,
            ),
            SizedBox(height: 12.h),

            //Government
            CustomTextField(
              label: 'Government',
              initialValue: c.government.value,
              onChanged: (v) => c.government.value = v,
            ),
            SizedBox(height: 12.h),

            //Address 
            CustomTextField(
              label: 'Address',
              initialValue: c.address.value,
              onChanged: (v) => c.address.value = v,
            ),
            SizedBox(height: 12.h),

            //Phone 
            CustomTextField(
              label: 'Phone Number',
              initialValue: c.phone.value,
              keyboard: TextInputType.phone,
              onChanged: (v) => c.phone.value = v,
            ),

            SizedBox(height: 50.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                ),
                onPressed: c.saveChanges,
                child: Text(
                  'Save',
                  style: TextStyle(color: AppColors.white, fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(height: 32.h),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                ),
                onPressed: c.logout,
                child: Text(
                  'logout',
                  style: TextStyle(color: AppColors.white, fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
