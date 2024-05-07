import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/login_page.dart';
import 'package:shopping_list_app/pages/shopping_list_page.dart';
import 'package:shopping_list_app/services/auth_service.dart';
import 'package:shopping_list_app/widgets/animated_text_field.dart';
import 'dart:developer';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? kAppDarkBackgroundColor : kAppLightBackgroundColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: textColor),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/images/sign_up.svg',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              AnimatedTextField(
                hint: "Email",
                controller: emailController,
                textColor: textColor, // Set text color for text field
              ),
              const SizedBox(height: 8),
              AnimatedTextField(
                hint: "Password",
                controller: passwordController,
                textColor: textColor, // Set text color for text field
              ),
              const SizedBox(height: 8),
              AnimatedTextField(
                hint: "Confirm Password",
                controller: confirmPasswordController,
                textColor: textColor, // Set text color for text field
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    signUpUser();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kVioletColor)),
                  child: const Text(
                    "Sign Up!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text(
                    "Already Registered? Tap Here!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        color: kVioletColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShoppingListPage()));
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUpUser() async {
    final user = await _auth.createUserWithEmailAndPassword(
        emailController.text, passwordController.text);
    if ((user != null) &&
        (passwordController.text == confirmPasswordController.text)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }
}
