import 'dart:convert';
import 'package:http/http.dart' as http;
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
      final response = await http.get(Uri.parse('http://localhost:8080/get-events-by-username/$userName'));

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
}
