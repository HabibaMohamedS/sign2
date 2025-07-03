import 'package:flutter/material.dart';

import 'package:sign2/features/Auth/view/login_screen.dart';

import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          width: 150,
          height: 90,
          child: Image.asset("assets/images/logo.png", fit: BoxFit.fill),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [TextButton(onPressed: () {}, child: const Text("Skip"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "Let’s create your\naccount!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Bottom section: buttons and social login
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignUpStep1(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign me up!',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                // Login text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Color.fromRGBO(82, 44, 93, 1)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromRGBO(21, 0, 22, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                const Center(
                  child: Text(
                    "Or login with account",
                    style: TextStyle(color: Color.fromRGBO(82, 44, 93, 1)),
                  ),
                ),
                const SizedBox(height: 12),

                // Social buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 28,
                          color: Color.fromRGBO(21, 0, 22, 1),
                        ),
                        label: const Text(
                          "Google",
                          style: TextStyle(color: Color.fromRGBO(21, 0, 22, 1)),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color.fromRGBO(21, 0, 22, 1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          size: 24,
                          color: Color.fromRGBO(21, 0, 22, 1),
                        ),
                        label: const Text(
                          "Facebook",
                          style: TextStyle(color: Color.fromRGBO(21, 0, 22, 1)),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color.fromRGBO(21, 0, 22, 1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
