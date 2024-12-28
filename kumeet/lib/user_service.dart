import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumeet/user.dart';
import 'event.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<String> login(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userName': userName, 'password': password}),
      );

      if (response.statusCode == 200) {
        return response.body; // Parse and return the JSON response
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<Map<String, dynamic>> signup(Map<String, String> userData) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body); // Return user data on success
      } else {
        throw Exception('Signup failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
    Future<List<Event>> getUserEvents(String userName) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/get-events-by-username/$userName'));

      if (response.statusCode == 200) {
        final List<dynamic> eventReferences = json.decode(response.body);
        return eventReferences.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
 Future<User> find(String userName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/find/$userName')
      );

      if (response.statusCode == 200) {
        // Decode the JSON response into a map and use `User.fromJson` to convert it to a User object
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to find user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<User> updateUser(String userName, User user) async {
      try {
      final response = await http.post(
        Uri.parse('$baseUrl/update/$userName'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body); // Return user data on success
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
