import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/shopping_list_page.dart';
import 'package:shopping_list_app/pages/signup_page.dart';
import 'package:shopping_list_app/services/auth_service.dart';
import 'package:shopping_list_app/widgets/animated_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                "Welcome Back!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: textColor, // Set text color based on theme
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/images/person_shopping.svg',
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
                textColor: textColor, // Set text color for text field
              ),
              const SizedBox(height: 8),
              AnimatedTextField(
                hint: "Password",
                controller: passwordController,
                textColor: textColor, // Set text color for text field
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    logInUser();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kVioletColor),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white, // Set text color for button
                    ),
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
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    "Not registered? Tap Here!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      color: kVioletColor,
                    ),
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
                          builder: (context) => const ShoppingListPage()),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey, // Set text color based on theme
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logInUser() async {
    final user = await _auth.loginUserWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User logged-in successfully!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ShoppingListPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please check your credentials.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }
}
