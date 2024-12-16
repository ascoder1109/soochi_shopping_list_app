class ItemDTO {
  final int id;
  String name; // Remove final
  String quantity; // Remove final
  bool isChecked;

  ItemDTO({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isChecked,
  });

  factory ItemDTO.fromJson(Map<String, dynamic> json) {
    return ItemDTO(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      isChecked: json['checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isChecked': isChecked,
    };
  }
}
