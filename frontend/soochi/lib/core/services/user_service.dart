import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/user_details_dto.dart';

class UserService {
  final String baseUrl;


  UserService({
    this.baseUrl = "http://192.168.193.193:8080",

  });

  static const String _userDetailsKey = 'user_details';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<UserDetailsDTO> fetchUserDetails() async {
    final url = Uri.parse('$baseUrl/api/user/details');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final userDetailsJson = jsonDecode(response.body);
      final userDetails = UserDetailsDTO.fromJson(userDetailsJson);
      await saveUserDetails(userDetails);
      return userDetails;
    } else {
      throw Exception('Failed to fetch user details: ${response.body}');
    }
  }

  Future<void> saveUserDetails(UserDetailsDTO userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDetailsKey, jsonEncode(userDetails.toJson()));
  }

  Future<UserDetailsDTO?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDetailsJson = prefs.getString(_userDetailsKey);
    if (userDetailsJson != null) {
      return UserDetailsDTO.fromJson(jsonDecode(userDetailsJson));
    }
    return null;
  }


  Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDetailsKey);
  }


}
