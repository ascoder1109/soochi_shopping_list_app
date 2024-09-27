import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soochi/model/user.dart';
import 'package:soochi/services/user_storage.dart';

class ApiService {
  final String baseUrl =
      'https://192.168.226.193:8443/api'; // Replace with your API URL

  // Method to handle login
  Future<User?> login(String email, String password) async {
    final String apiUrl = '$baseUrl/auth/login';

    // Prepare the request body
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    // Handle the response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      // Attempt to parse the User object from JSON
      try {
        User user = User.fromJson(jsonDecode(response.body));
        UserStorage.storeUser(user); // Store the user in UserStorage
        return user;
      } catch (e) {
        print('Error parsing JSON: $e');
        return null;
      }
    } else {
      print('Login failed: ${response.statusCode} ${response.body}');
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

  Future<User?> getCurrentUser() async {
    final String apiUrl = '$baseUrl/auth/me';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // Uncomment and add your Authorization token if needed
        // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
      },
    );

    if (response.statusCode == 200) {
      // Parse and return the User object
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Handle error (e.g., unauthorized)
      print(
          'Failed to fetch user details: ${response.statusCode} ${response.body}');
      return null;
    }
  }
}
