import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soochi/core/services/auth_service.dart';
import '../dtos/item_dto.dart';

class ItemService {
  final String baseUrl;

  ItemService({
    this.baseUrl = "http://192.168.193.193:8080",
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ItemDTO>> getItemsForShoppingList(int shoppingListId) async {
    final url = Uri.parse('$baseUrl/api/items/shopping-lists/$shoppingListId');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<ItemDTO> items = data.map((json) => ItemDTO.fromJson(json)).toList();

      _saveItemsLocally(shoppingListId, items);

      return items;
    } else {
      throw Exception('Failed to load items for shopping list $shoppingListId');
    }
  }

  Future<void> _saveItemsLocally(int shoppingListId, List<ItemDTO> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString('items_for_list_$shoppingListId', jsonData);
  }

  Future<List<ItemDTO>> getItemsFromLocalStorage(int shoppingListId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('items_for_list_$shoppingListId');

    if (savedData != null) {
      final List<dynamic> data = jsonDecode(savedData);
      return data.map((json) => ItemDTO.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<ItemDTO> toggleItemCheckbox(int shoppingListId, int itemId) async {
    final url = Uri.parse('$baseUrl/api/items/$itemId/toggle');
    final headers = await _getHeaders();

    final response = await http.patch(url, headers: headers);

    if (response.statusCode == 200) {
      final updatedItem = ItemDTO.fromJson(jsonDecode(response.body));

      // Update the local storage
      List<ItemDTO> currentItems = await getItemsFromLocalStorage(shoppingListId);
      currentItems = currentItems.map((item) {
        return item.id == updatedItem.id ? updatedItem : item;
      }).toList();

      await _saveItemsLocally(shoppingListId, currentItems);

      return updatedItem;
    } else {
      throw Exception('Failed to toggle checkbox for item');
    }
  }


  Future<ItemDTO> createItemForShoppingList(int shoppingListId, ItemDTO itemDTO) async {
    final url = Uri.parse('$baseUrl/api/items/shopping-lists/$shoppingListId');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(itemDTO.toJson()),
    );

    if (response.statusCode == 201) {
      final newItem = ItemDTO.fromJson(jsonDecode(response.body));

      List<ItemDTO> currentItems = await getItemsFromLocalStorage(shoppingListId);
      currentItems.add(newItem);
      await _saveItemsLocally(shoppingListId, currentItems);

      return newItem;
    } else {
      throw Exception('Failed to create item for shopping list $shoppingListId');
    }
  }


  Future<ItemDTO> updateItem(int shoppingListId, int itemId, ItemDTO itemDTO) async {
    final url = Uri.parse('$baseUrl/api/items/$itemId');
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(itemDTO.toJson()),
    );

    if (response.statusCode == 200) {
      final updatedItem = ItemDTO.fromJson(jsonDecode(response.body));

      // Update local storage
      List<ItemDTO> currentItems = await getItemsFromLocalStorage(shoppingListId);
      currentItems = currentItems.map((item) {
        return item.id == updatedItem.id ? updatedItem : item;
      }).toList();

      await _saveItemsLocally(shoppingListId, currentItems);

      return updatedItem;
    } else {
      throw Exception('Failed to update item');
    }
  }

  Future<void> deleteItem(int shoppingListId, int itemId) async {
    final url = Uri.parse('$baseUrl/api/items/$itemId');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {

      List<ItemDTO> currentItems = await getItemsFromLocalStorage(shoppingListId);
      currentItems.removeWhere((item) => item.id == itemId);

      await _saveItemsLocally(shoppingListId, currentItems);
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> clearItems(int shoppingListId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('items_for_list_$shoppingListId');
  }

}
