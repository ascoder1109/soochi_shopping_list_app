import 'package:flutter/material.dart';
import 'package:soochi/views/screens/dashboard.dart';
import 'package:soochi/views/screens/login_screen.dart';
import 'package:soochi/views/screens/signup_screen.dart';

class Routes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginScreen(), // Add default route
      dashboard: (context) => const Dashboard(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
    };
  }
}