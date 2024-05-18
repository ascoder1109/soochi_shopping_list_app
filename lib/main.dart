import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/models/item_model.dart';
import 'package:soochi/provider/item_list_model_provider.dart';
import 'package:soochi/screens/auth/login_page.dart';
import 'package:soochi/screens/auth/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ItemListModel())],
      child: MaterialApp(
        home: LoginPage(),
        theme: ThemeData(colorSchemeSeed: kVioletColor),
      ),
    );
  }
}
