class ItemModel {
  final String name;
  final String quantity;
  bool isChecked;
  ItemModel({
    required this.name,
    required this.quantity,
    this.isChecked = false,
  });
}
