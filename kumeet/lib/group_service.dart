import 'dart:convert';
import 'package:http/http.dart' as http;
import 'group.dart';

class GroupService {
  final String baseUrl = 'http://localhost:8080/api';

  // Method to create a group
  Future<bool> createGroup(Group group, String username) async {
    final url = Uri.parse('$baseUrl/creategroup/$username');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(group.toJson()), // Convert Group to JSON
      );

      // Debugging logs
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Group created successfully!');
        return true;
      } else {
        print('Failed to create group: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating group: $e');
      return false;
    }
  }

  // Method to get all groups
  Future<List<Group>> getGroups() async {
    final url = Uri.parse('$baseUrl/get-groups');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Debugging logs
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Group.fromJson(json)).toList();
      } else {
        print('Failed to fetch groups: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching groups: $e');
      return [];
    }
  }

  // Method to get groups by user
  Future<List<Group>> getGroupsByUser(String username) async {
    final url = Uri.parse('$baseUrl/get-groups-by-username/$username');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Debugging logs
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Group.fromJson(json)).toList();
      } else {
        print('Failed to fetch groups by user: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching groups by user: $e');
      return [];
    }
  }

  // Method to get owned groups
  Future<List<Group>> getOwnedGroups(String username) async {
    final url = Uri.parse('$baseUrl/get-groups-for-admin/$username');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Debugging logs
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Group.fromJson(json)).toList();
      } else {
        print('Failed to fetch owned groups: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching owned groups: $e');
      return [];
    }
  }
}