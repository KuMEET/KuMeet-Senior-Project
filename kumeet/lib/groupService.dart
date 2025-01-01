import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kumeet/event.dart';
import 'package:kumeet/user.dart';
import 'group.dart';
import 'package:path/path.dart' as p;  // For filename utilities

class GroupService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<bool> createGroup(Group group, String username, File? imageFile) async {
  final url = Uri.parse('$baseUrl/creategroup/$username');

  try {
    final request = http.MultipartRequest('POST', url);

    // Add fields for group creation
    request.fields['name'] = group.name;
    request.fields['capacity'] = group.capacity.toString();
    request.fields['visibility'] = group.visibility.toString();
    request.fields['categories'] = group.categories;

    // Add image file if provided
    if (imageFile != null) {
      final fileName = p.basename(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo', // Match the backend parameter name
          imageFile.path,
          filename: fileName,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Group created successfully with image!');
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
      if (response.statusCode == 200 || response.statusCode == 201) {
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
  Future<List<Group>> getGroupsByMember(String username) async {
    final url = Uri.parse('$baseUrl/get-groups-by-username-only-members/$username');
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

  Future<List<Group>> getOwnedGroups(String userName) async {
    final url = Uri.parse('$baseUrl/get-groups-for-admin/$userName');
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
        body: jsonEncode(group.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  Future<List<User>> showMembersOfGroup(String groupId) async{
      try {
      final response = await http.get(Uri.parse('$baseUrl/get-members-for-groups/$groupId'));
      if (response.statusCode == 200) {
        final List<dynamic> members = json.decode(response.body);
        return members.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch groups');
      }
    } catch (e) {
      throw Exception('Error fetching groups: $e');
    }
  }
  Future<List<User>> showAdminsOfGroup(String groupId) async {
  final url = Uri.parse('$baseUrl/get-admins-for-group/$groupId');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        // Parse directly as a list of users
        return data.map((json) => User.fromJson(json)).toList();
      } else if (data is Map) {
        // Handle case where the server returns a map (e.g., wrapping the list)
        final admins = data['admins'] as List;
        return admins.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } else {
      throw Exception('Failed to fetch admins: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Error fetching admins: $e');
  }
}
    Future<bool> deleteMemberFromGroup(String userName,String eventId) async {
    final url = Uri.parse('$baseUrl/remove-from-event/$userName/$eventId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete the event: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting the event: $e');
      return false;
    }
  }
      Future<bool> updateMemberRoleInGroup(String userName, String eventId,String role) async {
    final url = Uri.parse('$baseUrl/update-role-event/$userName/$eventId/$role');
    try {
      final response = await http.put(url);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Role updated successfully!');
        return true;
      } else {
        print('Failed to updated role: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updated group: $e');
      return false;
    }
  }

}
