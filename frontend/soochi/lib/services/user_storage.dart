import 'package:soochi/model/user.dart';

class UserStorage {
  static User? _currentUser;

  static void storeUser(User user) {
    _currentUser = user;
  }

  static User? retrieveUser() {
    return _currentUser;
  }
}
