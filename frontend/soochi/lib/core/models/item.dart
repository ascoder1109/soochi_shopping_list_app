class Item {
  final int id;
  final String name;
  final String quantity;
  final bool isChecked;
  final int shoppingListId;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isChecked,
    required this.shoppingListId,
  });

  // Convert a Item to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isChecked': isChecked,
      'shoppingListId': shoppingListId,
    };
  }


  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      isChecked: map['isChecked'],
      shoppingListId: map['shoppingListId'],
    );
  }


  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      isChecked: json['isChecked'],
      shoppingListId: json['shoppingListId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isChecked': isChecked,
      'shoppingListId': shoppingListId,
    };
  }
}
