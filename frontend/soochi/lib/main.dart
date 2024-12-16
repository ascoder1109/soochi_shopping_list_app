import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/routes.dart';

import 'package:soochi/core/services/auth_service.dart';
import 'package:soochi/views/viewmodels/login_viewmodel.dart';
import 'package:soochi/views/viewmodels/selected_shopping_list_view_model.dart';
import 'package:soochi/views/viewmodels/shopping_list_view_model.dart';
import 'package:soochi/views/viewmodels/signup_viewmodel.dart';
import 'package:soochi/views/viewmodels/user_view_model.dart';

import 'core/services/item_service.dart';
import 'core/services/shopping_list_service.dart';
import 'core/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),

        ChangeNotifierProvider(
          create: (_) => UserViewModel(userService)..fetchUserDetails(),
        ),

        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            authService: context.read<AuthService>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ShoppingListViewModel(shoppingListService: ShoppingListService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ShoppingListViewModel(shoppingListService: ShoppingListService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectedShoppingListViewModel(itemService: ItemService()),
        ),
        ChangeNotifierProvider<SignupViewModel>(
          create: (context) => SignupViewModel(
            authService: context.read<AuthService>(),
          ),
        ),
      ],
      child: MaterialApp(

        title: 'Soochi',
        initialRoute: Routes.login,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,

        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
