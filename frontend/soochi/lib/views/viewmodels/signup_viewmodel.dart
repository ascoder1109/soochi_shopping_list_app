import 'package:flutter/material.dart';
import '../../core/dtos/user_registration_dto.dart';
import '../../core/services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  SignupViewModel({required AuthService authService}) : _authService = authService;

  Future<void> signup(BuildContext context, UserRegistrationDTO registrationDTO) async {
    _setLoading(true);
    try {
      await _authService.registerUser(registrationDTO);
      _setLoading(false);
      _setErrorMessage('');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      _setLoading(false);


      if (error.toString().contains('User already exists')) {
        _setErrorMessage('User already exists. Please choose a different username or email.');
      } else {
        _setErrorMessage(error.toString());
      }
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
