import 'package:flutter/material.dart';

import '../../core/dtos/shopping_list_dto.dart';
import '../../core/dtos/shopping_list_request_dto.dart';
import '../../core/services/shopping_list_service.dart';

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListService shoppingListService;
  bool isLoading = false;
  List<ShoppingListDTO> shoppingLists = [];

  ShoppingListViewModel({required this.shoppingListService});

  // Fetch shopping lists
  Future<void> fetchShoppingLists() async {
    try {
      isLoading = true;
      notifyListeners();
      shoppingLists = await shoppingListService.getAllShoppingLists();
    } catch (e) {
      print("Error fetching shopping lists: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Add shopping list
  Future<void> addShoppingList(String name) async {
    final newList = ShoppingListRequestDTO(name: name);
    final newShoppingList = await shoppingListService.createShoppingList(newList);
    shoppingLists.add(newShoppingList);
    notifyListeners();
  }

  // Update shopping list
  Future<void> updateShoppingList(int id, String name) async {
    final updatedList = ShoppingListRequestDTO(name: name);
    final updatedShoppingList = await shoppingListService.updateShoppingList(id, updatedList);
    final index = shoppingLists.indexWhere((list) => list.id == id);
    if (index != -1) {
      shoppingLists[index] = updatedShoppingList;
      notifyListeners();
    }
  }

  // Delete shopping list
  Future<void> deleteShoppingList(int id) async {
    await shoppingListService.deleteShoppingList(id);
    shoppingLists.removeWhere((list) => list.id == id);
    notifyListeners();
  }


}
