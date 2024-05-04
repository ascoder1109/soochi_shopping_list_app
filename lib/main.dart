import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/login_page.dart';

import 'package:shopping_list_app/pages/shopping_list_page.dart';
import 'package:shopping_list_app/pages/signup_page.dart';

import 'package:shopping_list_app/provider/card_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: MaterialApp(
        title: "Shopping List App",
        home: SignUpPage(),
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: kVioletColor),
      ),
    );
    // return MaterialApp(
    //   title: "Shopping List App",
    //   home: const ShoppingListPage(),
    //   theme: ThemeData(useMaterial3: true),
    // );
  }
}
