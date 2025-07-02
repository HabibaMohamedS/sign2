import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign2/support/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final TextInputType keyboard;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.keyboard = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(               // ← user‑typed text color
          color: AppColors.darkPurple,
        ),
        readOnly: readOnly,
        initialValue: initialValue,
        keyboardType: keyboard,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.darkPurple),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.gray),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkPurple),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
