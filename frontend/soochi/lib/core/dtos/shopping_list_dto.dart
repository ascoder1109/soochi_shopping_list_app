class ShoppingListDTO {
  final int id;
  final String name;

  ShoppingListDTO({required this.id, required this.name});

  factory ShoppingListDTO.fromJson(Map<String, dynamic> json) {
    return ShoppingListDTO(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
