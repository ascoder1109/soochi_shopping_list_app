class ItemUpdateDTO {
  final String? name;
  final String? quantity;

  ItemUpdateDTO({
    this.name,
    this.quantity,
  });

  factory ItemUpdateDTO.fromJson(Map<String, dynamic> json) {
    return ItemUpdateDTO(
      name: json['name'],
      quantity: json['quantity'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}