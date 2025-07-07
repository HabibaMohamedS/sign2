import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign2/features/profile/viewmodel/profile_controller.dart';
import 'package:sign2/support/custom_widgets/custom_textfield.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'package:sign2/support/theme/app_images.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => _showAvatarPicker(context),
                child: Obx(() {
                  final file = controller.avatarFile.value;
                  return Container(
                    width: 120.r,               
                    height: 120.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,    
                    ),
                    clipBehavior: Clip.antiAlias, 
                    child: file != null
                        ? Image.file(
                            file,
                            fit: BoxFit.contain,  
                          )
                        : Image.asset(
                            AppImages.defaultAvatar,
                            fit: BoxFit.contain,
                          ),
                  );
                }),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                label: 'Username',
                initialValue: controller.username.value,
                onChanged: (v) => controller.username.value = v,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'Email',
                initialValue: controller.email,
                readOnly: true,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'Address',
                initialValue: controller.address.value,
                onChanged: (v) => controller.address.value = v,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'Phone Number',
                initialValue: controller.phone.value,
                keyboard: TextInputType.phone,
                onChanged: (v) => controller.phone.value = v,
              ),
              SizedBox(height: 12.h),

              Obx(() {
                final dobStr = controller.dob.value == null
                    ? ''
                    : '${controller.dob.value!.day}/${controller.dob.value!.month}/${controller.dob.value!.year}';
                return CustomTextField(
                  label: 'Date of Birth',
                  initialValue: dobStr,
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.dob.value = picked;
                  },
                );
              }),

              SizedBox(height:50.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h,horizontal: 12.w),
                  ),
                  onPressed: controller.saveChanges,
                  child: Text('Save',style: TextStyle(color: AppColors.white,fontSize: 20.sp)),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      );
  }

  void _showAvatarPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.darkPurple),
              title: const Text('Camera'),
              onTap: () {
                controller.changeAvatar(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.darkPurple),
              title: const Text('Gallery'),
              onTap: () {
                controller.changeAvatar(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

