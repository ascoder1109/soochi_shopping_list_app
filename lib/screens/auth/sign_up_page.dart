// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/screens/auth/login_page.dart';
// import 'package:soochi/screens/shopping_list_page/shopping_list_page.dart';
import 'package:soochi/services/firebase_auth_service.dart';
// import 'package:soochi/screens/auth/widgets/animated_text_field_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: kAppWhiteColor, statusBarBrightness: Brightness.dark)
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      // backgroundColor: kAppWhiteColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  " Hello There 👋",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(
                  height: 64,
                ),
                const Center(
                  child: Image(
                    image: Svg('assets/images/shopping.svg'),
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
                TextField(
                  // style: const TextStyle(color: Colors.black),
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: kVioletColor, width: 3),
                    ),
                    hintText: "Enter your email",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  // style: const TextStyle(color: Colors.black),
                  controller: passwordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: kVioletColor, width: 3),
                    ),
                    hintText: "Enter your password",
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  // style: const TextStyle(color: Colors.black),
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: kVioletColor, width: 3),
                    ),
                    hintText: "Re-enter your password",
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kVioletColor),
                        foregroundColor:
                            MaterialStateProperty.all(kAppWhiteColor)),
                    onPressed: () {
                      _signUp();
                    },
                    child: const Text('Sign-Up'),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: const Text(
                      "Already a user? Tap here to log in!",
                      style: TextStyle(
                          color: kVioletColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );

    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null && password == confirmPassword) {
      // print("User registered successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have successfully signed up!'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong.'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      // print("Some error occured");
    }
  }
}
