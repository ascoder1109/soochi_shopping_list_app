import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soochi/core/services/item_service.dart';
import 'package:soochi/core/services/shopping_list_service.dart';
import 'package:soochi/core/services/user_service.dart';

import '../../views/viewmodels/selected_shopping_list_view_model.dart';
import '../dtos/user_login_request_dto.dart';
import '../dtos/user_login_response_dto.dart';
import '../dtos/user_registration_dto.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  final String apiName;
  final String apiKey;

  AuthService({
    this.baseUrl = "http://192.168.193.193:8080",
    this.apiName = "SOOCHI_AUTH_API",
    this.apiKey = "sdodnfuon3489f890waef891h24ionsaduiofb89q3n",
  });

  static const String _tokenKey = 'auth_token';


  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'API_NAME': apiName,
      'API_KEY': apiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }


  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }


  Future<UserRegistrationDTO> registerUser(UserRegistrationDTO registrationDto) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(registrationDto.toJson()),
    );

    if (response.statusCode == 201) {
      return UserRegistrationDTO.fromJson(jsonDecode(response.body));
    } else {

      print('Error Response: ${response.body}');
      throw Exception('Failed to register user: ${response.body}');
    }
  }


  Future<UserLoginResponseDTO> loginUser(UserLoginRequestDTO loginDto) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(loginDto.toJson()),
    );

    if (response.statusCode == 200) {
      final loginResponse = UserLoginResponseDTO.fromJson(jsonDecode(response.body));
      await saveToken(loginResponse.token);

      final userService = UserService();
      await userService.clearUserDetails();

      return loginResponse;
    } else {
      throw Exception('Failed to login user: ${response.body}');
    }
  }


  Future<void> logout() async {
    await clearToken();
    print('Auth token cleared');

    final userService = UserService();
    await userService.clearUserDetails();
    print('User details cleared');

    final shoppingListService = ShoppingListService();
    await shoppingListService.clearShoppingLists();
    print('Shopping lists cleared');

    final itemService = ItemService();
    final shoppingLists = await shoppingListService.getShoppingListsFromLocalStorage();
    for (var shoppingList in shoppingLists) {
      await itemService.clearItems(shoppingList.id);
    }
    print('Items cleared for all shopping lists');


  }



  Future<void> someAuthenticatedRequest() async {
    final url = Uri.parse('$baseUrl/api/some-protected-endpoint');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('Authenticated request successful: ${response.body}');
    } else {
      throw Exception('Failed authenticated request: ${response.body}');
    }
  }
}
