class ShoppingListRequestDTO {
  final String name;

  ShoppingListRequestDTO({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
