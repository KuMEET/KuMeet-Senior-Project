import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumeet/event.dart';
import 'group.dart';

class GroupService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<bool> createGroup(Group group, String username) async {
    final url = Uri.parse('$baseUrl/creategroup/$username');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(group.toJson()),
      );
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addEventToGroup(String groupId, String eventId) async {
    final url = Uri.parse('$baseUrl/add-event-to-group/$eventId/$groupId');
    try {
      final response = await http.post(url);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Group>> getGroups() async {
    final url = Uri.parse('$baseUrl/get-groups');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Group.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Event>> getEventsforGroups(Group group) async {
    final groupId = group.id;
    final url = Uri.parse('$baseUrl/get-events-for-groups/$groupId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Group>> getGroupsByUser(String username) async {
    final url = Uri.parse('$baseUrl/get-groups-by-username/$username');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Group.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Group>> getOwnedGroups(String username) async {
    final url = Uri.parse('$baseUrl/get-groups-for-admin/$username');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Group.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteGroup(Group group) async {
    final url = Uri.parse('$baseUrl/delete-group');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(group.toJson2()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateGroup(Group group, String? groupId) async {
    final url = Uri.parse('$baseUrl/update-group/$groupId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(group.toJson2()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
