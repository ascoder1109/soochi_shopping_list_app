

import 'shopping_list.dart';

class User {
  final int? id;
  final String userName;
  final String email;
  final String password;
  final List<ShoppingList> shoppingList;


  User({
    this.id,
    required this.userName,
    required this.email,
    required this.password,
    this.shoppingList = const [],
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      password: json['password'],
      shoppingList: (json['shoppingList'] as List<dynamic>?)
          ?.map((item) => ShoppingList.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'shoppingList': shoppingList.map((item) => item.toJson()).toList(),
    };
  }
}
