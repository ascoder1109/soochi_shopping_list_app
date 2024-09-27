import 'package:flutter/cupertino.dart';
import 'package:soochi/views/dashboard.dart';
import 'package:soochi/views/login_view.dart';
import 'package:soochi/views/signup_view.dart';

class Routes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginView(), // Add default route
      dashboard: (context) => const Dashboard(),
      login: (context) => const LoginView(),
      signup: (context) => const SignupView(),
    };
  }
}
