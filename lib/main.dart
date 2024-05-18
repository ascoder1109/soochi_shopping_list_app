import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/models/item_model.dart';
import 'package:soochi/provider/item_list_model_provider.dart';
import 'package:soochi/provider/theme_changer_provider.dart';
import 'package:soochi/screens/auth/login_page.dart';
import 'package:soochi/screens/auth/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemListModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Consumer<ThemeChanger>(
            builder: (context, themeChanger, _) {
              return MaterialApp(
                home: const LoginPage(),
                theme: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: kVioletColor,
                    background: kAppWhiteColor,
                    brightness: Brightness.light,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: kAppWhiteColor, // Light mode app bar color
                  ),
                  scaffoldBackgroundColor:
                      Colors.white, // Light mode scaffold color
                ),
                darkTheme: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: kVioletColor,
                    background: kAppBlackColor,
                    brightness: Brightness.dark,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: kAppBlackColor, // Dark mode app bar color
                    foregroundColor: kAppWhiteColor,
                  ),
                  scaffoldBackgroundColor:
                      Colors.black, // Dark mode scaffold color
                ),
                themeMode: themeChanger.themeMode,
              );
            },
          );
        },
      ),
    );
  }
}
