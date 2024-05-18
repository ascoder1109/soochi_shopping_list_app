import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/screens/auth/sign_up_page.dart';
import 'package:soochi/screens/shopping_list_page/shopping_list_page.dart';
import 'package:soochi/services/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();

  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
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
                  " Welcome Back!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(
                  height: 64,
                ),
                const Center(
                  child: Image(
                    image: Svg('assets/images/login.svg'),
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
                TextField(
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
                      borderSide: BorderSide(color: kVioletColor, width: 3),
                    ),
                    hintText: "Enter your email",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
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
                      borderSide: BorderSide(color: kVioletColor, width: 3),
                    ),
                    hintText: "Enter your password",
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 8,
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
                      _logIn();
                    },
                    child: Text('Log-In'),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ));
                    },
                    child: Text(
                      "Not a user? Tap here to sign in!",
                      style: TextStyle(
                          color: kVioletColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ShoppingListPage(),
                      ));
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
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

  void _logIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    Navigator.pop(context);

    if (user != null) {
      print("User login successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have successfully logged in!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ShoppingListPage(),
      ));
    } else {
      print("Login failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
