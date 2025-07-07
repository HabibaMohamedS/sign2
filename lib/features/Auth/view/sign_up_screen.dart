// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/support/theme/app_colors.dart';
import 'sign_up_step2.dart';
import 'welcome_screen.dart';

class SignUpStep1 extends StatefulWidget {
  const SignUpStep1({super.key});

  @override
  _SignUpStep1State createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent automatic resizing
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5EDF8), Color(0xFFFDEEEA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Top Section (Back + Title + Step)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                alignment: Alignment.topLeft,
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WelcomeScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "6".tr,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "7".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 2,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Fields (Centered)
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: username,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "8".tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: TextStyle(
                                        color: AppColors.darkNavy,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: '10'.tr,
                                        hintText: '9'.tr,
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: email,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "11".tr;
                                        } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                                          return "12".tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: TextStyle(
                                        color: AppColors.darkNavy,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: '13'.tr,
                                        hintText: '14'.tr,
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "15".tr;
                                        } else if (value.length < 8) {
                                          return "16".tr;
                                        } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]').hasMatch(value)) {
                                          return "17".tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: password,
                                      style: TextStyle(
                                        color: AppColors.darkNavy,
                                      ),
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        labelText: '19'.tr,
                                        hintText: '18'.tr,
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: confirmPassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "20".tr;
                                        } else if (value != password.text) {
                                          return "21".tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: TextStyle(
                                        color: AppColors.darkNavy,
                                      ),
                                      obscureText: !_isConfirmPasswordVisible,
                                      decoration: InputDecoration(
                                        labelText: '22'.tr,
                                        hintText: '23'.tr,
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isConfirmPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isConfirmPasswordVisible =
                                                  !_isConfirmPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom: Continue button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SignUpStep2(
                                            userData: [
                                              username.text,
                                              email.text,
                                              password.text,
                                            ],
                                          ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                '24'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
