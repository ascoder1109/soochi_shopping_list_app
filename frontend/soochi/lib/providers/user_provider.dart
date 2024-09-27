import 'package:flutter/cupertino.dart';
import 'package:soochi/model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(String name, String email) {
    _user = User(name: name, email: email);
    notifyListeners();
  }
}
