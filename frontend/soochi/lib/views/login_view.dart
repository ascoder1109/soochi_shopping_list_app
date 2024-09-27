import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soochi/model/user.dart';
import 'package:soochi/routes.dart';
import 'package:soochi/services/api_service.dart'; // Import the ApiService // Import your User model

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService

  Future<void> _login(BuildContext context) async {
    // Show loading indicator
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CupertinoAlertDialog(
            title: const Text('Logging in...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(height: 16),
                const Text('Please wait while we log you in.'),
              ],
            ),
          ),
        );
      },
    );

    // Call the login method from ApiService
    User? user = await apiService.login(
      emailController.text,
      passwordController.text,
    );

    // Dismiss the loading dialog
    Navigator.of(context).pop();

    // Handle the response
    if (user != null) {
      // Successfully logged in
      print('Login successful: ${user.name}');
      // Navigate to the dashboard
      Navigator.popAndPushNamed(context, Routes.dashboard);
    } else {
      // Login failed
      print('Login failed');
      // Show an error dialog for login failure
      _showErrorDialog(context, 'Login failed. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Soochi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            ),
            const SizedBox(height: 70),
            CupertinoTextField(
              controller: emailController,
              placeholder: 'Email',
              placeholderStyle:
                  const TextStyle(color: CupertinoColors.systemGrey),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.lightBackgroundGray),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 16.0),
            CupertinoTextField(
              controller: passwordController,
              placeholder: 'Password',
              placeholderStyle:
                  const TextStyle(color: CupertinoColors.systemGrey),
              obscureText: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.lightBackgroundGray),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 20.0),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              onPressed: () {
                _login(context);
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: CupertinoButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, Routes.signup);
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: CupertinoColors.systemBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
