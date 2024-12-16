import 'item.dart';
import 'user.dart';

class ShoppingList {
  final int? id;
  final String name;
  final User? user;
  final List<Item> items;

  // Constructor
  ShoppingList({
    this.id,
    required this.name,
    this.user,
    this.items = const [],
  });


  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList() ??
          [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user': user?.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
