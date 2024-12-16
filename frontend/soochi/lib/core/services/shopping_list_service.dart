import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soochi/core/services/auth_service.dart';


import '../dtos/shopping_list_dto.dart';
import '../dtos/shopping_list_request_dto.dart';

class ShoppingListService {
  final String baseUrl;

  ShoppingListService({
    this.baseUrl = "http://192.168.193.193:8080",
  });


  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ShoppingListDTO>> getAllShoppingLists() async {
    final url = Uri.parse('$baseUrl/api/shopping-lists');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<ShoppingListDTO> shoppingLists = data
          .map((json) => ShoppingListDTO.fromJson(json))
          .toList();

      _saveShoppingListsLocally(shoppingLists);

      return shoppingLists;
    } else {
      throw Exception('Failed to load shopping lists');
    }
  }


  Future<List<ShoppingListDTO>> getShoppingListsFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('shopping_lists');

    if (savedData != null) {
      final List<dynamic> data = jsonDecode(savedData);
      return data.map((json) => ShoppingListDTO.fromJson(json)).toList();
    } else {
      return [];
    }
  }


  Future<void> _saveShoppingListsLocally(List<ShoppingListDTO> shoppingLists) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(shoppingLists.map((item) => item.toJson()).toList());
    await prefs.setString('shopping_lists', jsonData);
  }


  Future<ShoppingListDTO> getShoppingListById(int id) async {
    final url = Uri.parse('$baseUrl/api/shopping-lists/$id');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final shoppingList = ShoppingListDTO.fromJson(jsonDecode(response.body));


      _saveShoppingListsLocally([shoppingList]);

      return shoppingList;
    } else {
      throw Exception('Failed to load shopping list');
    }
  }

  Future<ShoppingListDTO> createShoppingList(ShoppingListRequestDTO requestDTO) async {
    final url = Uri.parse('$baseUrl/api/shopping-lists');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestDTO.toJson()),
    );

    if (response.statusCode == 201) {
      final newShoppingList = ShoppingListDTO.fromJson(jsonDecode(response.body));


      List<ShoppingListDTO> currentLists = await getShoppingListsFromLocalStorage();
      currentLists.add(newShoppingList);


      _saveShoppingListsLocally(currentLists);

      return newShoppingList;
    } else {
      throw Exception('Failed to create shopping list');
    }
  }


  Future<ShoppingListDTO> updateShoppingList(int id, ShoppingListRequestDTO requestDTO) async {
    final url = Uri.parse('$baseUrl/api/shopping-lists/$id');
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(requestDTO.toJson()),
    );

    if (response.statusCode == 200) {
      final updatedShoppingList = ShoppingListDTO.fromJson(jsonDecode(response.body));


      List<ShoppingListDTO> currentLists = await getShoppingListsFromLocalStorage();
      currentLists = currentLists.map((item) {
        return item.id == updatedShoppingList.id ? updatedShoppingList : item;
      }).toList();

      _saveShoppingListsLocally(currentLists);

      return updatedShoppingList;
    } else {
      throw Exception('Failed to update shopping list');
    }
  }

  Future<void> deleteShoppingList(int id) async {
    final url = Uri.parse('$baseUrl/api/shopping-lists/$id');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      // Remove the shopping list from local storage
      List<ShoppingListDTO> currentLists = await getShoppingListsFromLocalStorage();
      currentLists.removeWhere((item) => item.id == id);

      _saveShoppingListsLocally(currentLists);
    } else {
      throw Exception('Failed to delete shopping list');
    }
  }

  Future<void> clearShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('shopping_lists');
    print('Cleared shopping lists from local storage');
  }

}
