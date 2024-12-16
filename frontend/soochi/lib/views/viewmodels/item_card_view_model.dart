import 'package:flutter/material.dart';
import 'package:soochi/core/dtos/item_dto.dart';
import 'package:soochi/core/services/item_service.dart'; // Import the ItemService

class ItemCardViewModel extends ChangeNotifier {
  final ItemDTO item;
  final ItemService itemService;

  ItemCardViewModel(this.item, this.itemService);


  Future<void> toggleCheck(int shoppingListId) async {
    try {

      ItemDTO updatedItem = await itemService.toggleItemCheckbox(shoppingListId, item.id);


      item.isChecked = updatedItem.isChecked;


      notifyListeners();
    } catch (e) {

      print("Error toggling checkbox: $e");
    }
  }

  Future<void> updateItem(int shoppingListId, String newName, String newQuantity) async {
    try {
      // Create an updated ItemDTO with the new data
      final updatedItemDTO = ItemDTO(
        id: item.id,
        name: newName,
        quantity: newQuantity,
        isChecked: item.isChecked,
      );


      final updatedItem = await itemService.updateItem(shoppingListId, item.id, updatedItemDTO);

      item.name = updatedItem.name;
      item.quantity = updatedItem.quantity;

      notifyListeners();
    } catch (e) {
      print("Error updating item: $e");
    }
  }




}
