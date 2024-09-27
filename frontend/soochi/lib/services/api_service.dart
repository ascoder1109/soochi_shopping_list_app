import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soochi/model/user.dart';
import 'package:soochi/services/user_storage.dart';

class ApiService {
  final String baseUrl = 'https://192.168.226.193:8443/api'; // Replace with your API URL

  // Method to handle login
  Future<User?> login(String email, String password) async {
    final String apiUrl = '$baseUrl/auth/login';

    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    print('Request body: ${jsonEncode(requestBody)}'); // Log the request body

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        try {
          User user = User.fromJson(jsonDecode(response.body));
          UserStorage.storeUser(user);
          return user;
        } catch (e) {
          print('Error parsing JSON: $e');
          return null;
        }
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e'); // Log any other errors
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    final String apiUrl = '$baseUrl/auth/register';

    final Map<String, String> requestBody = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Registration failed: ${response.statusCode} ${response.body}');
      return false;
    }
  }
}
