import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/login_page.dart';
import 'package:shopping_list_app/pages/shopping_list_page.dart';
import 'package:shopping_list_app/provider/card_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
        // brightness: Brightness.0,
        // primaryColor: kVioletColor,
        colorSchemeSeed: kVioletColor
        // backgroundColor: kLightBackgroundColor,
        // Define other light theme properties as needed
        );

    final darkTheme = ThemeData(
        brightness: Brightness.dark,
        // primaryColor: kVioletColor,
        colorSchemeSeed: kVioletColor
        // backgroundColor: kDarkBackgroundColor,
        // Define other dark theme properties as needed
        );

    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: MaterialApp(
        title: "Shopping List App",
        home: const LoginPage(),
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        // Use system theme mode (light/dark)
      ),
    );
  }
}
