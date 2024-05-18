import 'package:flutter/material.dart';
import 'package:soochi/models/item_model.dart';

class ItemListModel extends ChangeNotifier {
  List<ItemModel> _items = []; // List to hold items

  // Getter for accessing items
  List<ItemModel> get items => _items;

  void addItem(ItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  void toggleItem(int index) {
    _items[index].isChecked = !_items[index].isChecked;
    notifyListeners();
  }

  void deleteItem(ItemModel item) {
    _items.remove(item);
    notifyListeners();
  }
}
