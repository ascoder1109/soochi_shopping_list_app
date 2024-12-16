import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:soochi/views/viewmodels/shopping_list_view_model.dart';
import 'package:soochi/views/viewmodels/user_view_model.dart';

import '../../core/dtos/user_login_request_dto.dart';
import '../../core/dtos/user_login_response_dto.dart';
import '../../core/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  LoginViewModel({required AuthService authService}) : _authService = authService;


  Future<void> login(BuildContext context, UserLoginRequestDTO loginRequestDTO) async {
    _setLoading(true);
    try {
      UserLoginResponseDTO response = await _authService.loginUser(loginRequestDTO);

      await Provider.of<UserViewModel>(context, listen: false).fetchUserDetails();

      // Fetch shopping lists after login
      final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context, listen: false);
      await shoppingListViewModel.fetchShoppingLists();

      _setLoading(false);
      _setErrorMessage('');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (error) {
      _setLoading(false);
      _setErrorMessage(error.toString());
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
