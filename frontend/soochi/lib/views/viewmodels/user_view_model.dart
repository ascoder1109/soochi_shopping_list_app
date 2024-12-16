import 'package:flutter/material.dart';

import '../../core/dtos/user_details_dto.dart';
import '../../core/services/user_service.dart';


class UserViewModel extends ChangeNotifier {
  final UserService userService;

  UserDetailsDTO? _userDetails;
  UserDetailsDTO? get userDetails => _userDetails;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserViewModel(this.userService);

  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userDetails = await userService.fetchUserDetails();
    } catch (e) {
      debugPrint('Error fetching user details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }
}
