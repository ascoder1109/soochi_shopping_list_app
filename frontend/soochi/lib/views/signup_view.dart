import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soochi/routes.dart';
import 'package:soochi/services/api_service.dart'; // Import the ApiService

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService

  Future<void> _register(BuildContext context) async {
    // Validate the password confirmation
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog(context, "Passwords do not match!");
      return;
    }

    // Show loading indicator
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CupertinoAlertDialog(
            title: const Text('Registering...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(height: 16),
                const Text('Please wait while we register you.'),
              ],
            ),
          ),
        );
      },
    );

    // Call the register method from ApiService
    bool success = await apiService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    // Dismiss the loading dialog
    Navigator.of(context).pop();

    // Handle the response
    if (success) {
      // Successfully registered
      print('Registration successful');
      // Show success message
      _showSuccessDialog(context, 'User Registered Successfully');
      // Optionally, navigate to the login view after a delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.popAndPushNamed(context, Routes.login);
      });
    } else {
      // Registration failed
      print('Registration failed');
      // Show an error dialog for registration failure
      _showErrorDialog(context, 'Registration failed. Please try again.');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
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
      child: SafeArea(
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Soochi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: 'Name',
                    placeholderStyle:
                        const TextStyle(color: CupertinoColors.systemGrey),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.lightBackgroundGray),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoTextField(
                    controller: emailController,
                    placeholder: 'Email',
                    placeholderStyle:
                        const TextStyle(color: CupertinoColors.systemGrey),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.lightBackgroundGray),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.lightBackgroundGray),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoTextField(
                    controller: confirmPasswordController,
                    placeholder: 'Confirm Password',
                    placeholderStyle:
                        const TextStyle(color: CupertinoColors.systemGrey),
                    obscureText: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CupertinoColors.lightBackgroundGray),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          onPressed: () {
                            _register(context);
                          },
                          child: const Text(
                            'Sign-Up!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, Routes.login);
                      },
                      child: const Text(
                        'Already have an account? Log-In',
                        style: TextStyle(color: CupertinoColors.systemBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
