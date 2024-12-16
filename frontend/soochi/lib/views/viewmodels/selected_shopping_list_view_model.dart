import 'package:flutter/material.dart';
import 'package:soochi/core/dtos/item_dto.dart';
import 'package:soochi/core/services/item_service.dart';

class SelectedShoppingListViewModel extends ChangeNotifier {
  int? _selectedListId;
  String? _selectedListName;
  List<ItemDTO> _items = [];
  bool _isLoadingItems = false;

  int? get selectedListId => _selectedListId;
  String? get selectedListName => _selectedListName;
  List<ItemDTO> get items => _items;
  bool get isLoadingItems => _isLoadingItems;

  final ItemService itemService;

  SelectedShoppingListViewModel({required this.itemService});

  // Select a shopping list and fetch its items
  void selectShoppingList(int id, String name) {
    _selectedListId = id;
    _selectedListName = name;
    _fetchItemsForSelectedList();
    notifyListeners();
  }

  // Fetch items for the selected shopping list
  Future<void> _fetchItemsForSelectedList() async {
    if (_selectedListId == null) return;

    _isLoadingItems = true;
    notifyListeners();

    try {
      _items = await itemService.getItemsForShoppingList(_selectedListId!);
    } catch (e) {
      print("Error fetching items: $e");
      _items = [];
    } finally {
      _isLoadingItems = false;
      notifyListeners();
    }

    Future<void> deleteItem(int itemId) async {
      if (_selectedListId == null) {
        throw Exception("No shopping list selected");
      }

      _isLoadingItems = true;
      notifyListeners();

      try {
        await itemService.deleteItem(_selectedListId!, itemId);

        _items.removeWhere((item) => item.id == itemId);

        notifyListeners();
      } catch (e) {
        print("Error deleting item: $e");
        throw Exception("Failed to delete item");
      } finally {
        _isLoadingItems = false;
        notifyListeners();
      }
    }

  }


  Future<void> addItem(ItemDTO newItem) async {
    if (_selectedListId == null) {
      throw Exception("No shopping list selected");
    }

    _isLoadingItems = true;
    notifyListeners();

    try {
      final createdItem =
      await itemService.createItemForShoppingList(_selectedListId!, newItem);

      _items.add(createdItem);
      notifyListeners();
    } catch (e) {
      print("Error adding item: $e");
      throw Exception("Failed to add item");
    } finally {
      _isLoadingItems = false;
      notifyListeners();
    }
  }

  Future<void> deleteItem(int itemId) async {
    if (_selectedListId == null) {
      throw Exception("No shopping list selected");
    }

    _isLoadingItems = true;
    notifyListeners();

    try {
      await itemService.deleteItem(_selectedListId!, itemId);

      _items.removeWhere((item) => item.id == itemId);

      notifyListeners();
    } catch (e) {
      print("Error deleting item: $e");
      throw Exception("Failed to delete item");
    } finally {
      _isLoadingItems = false;
      notifyListeners();
    }
  }

  void clearState() {
    _selectedListId = null;
    _selectedListName = null;
    _items = [];
    _isLoadingItems = false;
    notifyListeners();
  }

}
