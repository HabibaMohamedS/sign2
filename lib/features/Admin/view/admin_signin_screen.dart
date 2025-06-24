import 'package:flutter/material.dart';
import 'package:sign2/features/Admin/model/data_source_services/admin_data_source.dart';
import 'package:sign2/features/Admin/model/data_source_services/admin_firebase_impl.dart';
import 'package:sign2/support/custom_widgets/custom_elevated_button.dart';
import 'package:sign2/support/custom_widgets/custom_form_field.dart';
import 'package:sign2/support/theme/app_text_styles.dart';


class AdminSigninScreen extends StatefulWidget {
  const AdminSigninScreen({super.key});

  @override
  State<AdminSigninScreen> createState() => _AdminSigninScreenState();
}

class _AdminSigninScreenState extends State<AdminSigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ID';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      // Perform sign-in logic here
      //TODO:Dependency injection
      AdminDataSource adminDataSource = AdminFirebaseImpl();
      String username = _usernameController.text;
      String password = _passwordController.text;
      SignInResult result = await adminDataSource.signIn(username, password);
      if (result.success) {
        // Navigate to the next screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in successful')),
        );
       // Navigator.pushReplacementNamed(context, '/admin_home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? 'Sign-in failed')),
        );
      }
    }
    // Handle error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sign In', style: AppTextStyle.heading),
            CustomFormField(
              controller: _usernameController,
              hintText: 'Enter your ID',
              validator: _usernameValidator,
              fieldLabel: 'Admin ID',
            ),
            CustomFormField(
                controller: _passwordController,
                hintText: 'Password',
                validator: _passwordValidator,
                fieldLabel: 'Password'),
            const SizedBox(height: 20),
            CustomElevatedButton(buttonText: 'Sign in', onPressed: _signIn)
          ],
        ),
      ),
    );
  }
}
