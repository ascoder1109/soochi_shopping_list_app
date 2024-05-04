import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/config.dart';
import 'package:shopping_list_app/pages/login_page.dart';
import 'package:shopping_list_app/pages/shopping_list_page.dart';
import 'package:shopping_list_app/widgets/animated_text_field.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void signUpUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(registration), // Replace with your backend URL
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          // Registration successful, you can navigate to the next screen or perform other actions
          print('Registration successful');
        } else {
          // Registration failed, handle error
          print('Registration failed');
        }
      } catch (e) {
        // Exception occurred during HTTP request
        print('Error: $e');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
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
              const Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
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
                hint: "Email ID",
                controller: emailController,
              ),
              const SizedBox(height: 8),
              AnimatedTextField(
                hint: "Password",
                controller: passwordController,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
}
