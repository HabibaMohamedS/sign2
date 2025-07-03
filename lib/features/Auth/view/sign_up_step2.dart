import 'package:flutter/material.dart';
import 'package:gp_dictionary/features/Auth/Controller/firebase_auth.dart';
import 'package:gp_dictionary/features/Auth/model/UserModel.dart';
import 'package:gp_dictionary/support/theme/app_colors.dart';

class SignUpStep2 extends StatefulWidget {
  final List<String> userData;
  const SignUpStep2({super.key, required this.userData});

  @override
  _SignUpStep2State createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final _formKey = GlobalKey<FormState>();

  final _govController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _govController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (_formKey.currentState!.validate()) {
      UserModel user = UserModel(
          username: widget.userData[0],
          email: widget.userData[1],
          password: widget.userData[2],
          government: _govController.text,
          address: _addressController.text,
          phoneNumber: _phoneController.text);
      FirebaseAuthentication auth = FirebaseAuthentication();
      String result = await auth.register(user);
      print(result);
    }
  }

  void _onSkip() {
    // Handle skip functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent auto resize
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
                        // Top Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Back + Skip
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    onPressed: _onSkip,
                                    child: const Text(
                                      "Skip",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Step 2 out of 2",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 2,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            color: Colors.deepPurple)),
                                    Expanded(
                                        child: Container(
                                            color: Colors.deepPurple)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Centered Form Fields
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      style:
                                          TextStyle(color: AppColors.darkNavy),
                                      controller: _govController,
                                      decoration: InputDecoration(
                                        labelText: 'Government',
                                        hintText: 'Enter Government',
                                        prefixIcon: const Icon(
                                            Icons.location_on_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your government'
                                          : null,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      style:
                                          TextStyle(color: AppColors.darkNavy),
                                      controller: _addressController,
                                      decoration: InputDecoration(
                                        labelText: 'Address',
                                        hintText: 'Enter Address',
                                        prefixIcon:
                                            const Icon(Icons.home_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your address'
                                          : null,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      style:
                                          TextStyle(color: AppColors.darkNavy),
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone number',
                                        hintText: 'Enter Phone number',
                                        prefixIcon:
                                            const Icon(Icons.phone_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your phone number'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom: Continue Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        )
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
