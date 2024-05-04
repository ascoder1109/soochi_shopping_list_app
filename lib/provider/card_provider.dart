import 'package:flutter/foundation.dart';
import 'package:shopping_list_app/models/item_model.dart';

class CardProvider extends ChangeNotifier {
  List<ShoppingListItem> _items = [];
  List<ShoppingListItem> get items => _items;

  void addItem(String itemName, String quantity) {
    ShoppingListItem newItem =
        ShoppingListItem(itemName: itemName, quantity: quantity);
    _items.add(newItem);
    notifyListeners();
  }

  void editItem(int index, String itemName, String quantity) {
    if (index >= 0 && index < _items.length) {
      _items[index].itemName = itemName;
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void deleteItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
