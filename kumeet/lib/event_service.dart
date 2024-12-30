import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumeet/user.dart';
import 'package:kumeet/userReference.dart';
import 'event.dart';

class EventService {
  final String baseUrl = 'http://localhost:8080/api';

  // Method to create an event
  Future<bool> createEvent(Event event, String username) async {
    final url = Uri.parse('$baseUrl/create-event/$username');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson()), // Convert Event to JSON
      );

      if (response.statusCode == 201) {
        print('Event created successfully!');
        return true;
      } else {
        print('Failed to create event: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating event: $e');
      return false;
    }
  }
  Future<bool> joinEvent(String userName, String eventId) async {
    final url = Uri.parse('$baseUrl/add-to-event/$userName/$eventId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Successfully joined event.');
        return true;
      } else {
        print('Failed to join event. Status: ${response.statusCode}');
        print('Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error joining event: $e');
      return false;
    }
  }

  // Method to fetch all events
  Future<List<Event>> getEvents() async {
    final url = Uri.parse('$baseUrl/get-events');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        print('Failed to fetch events: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Event>> getEventsByUser(String username) async {
    final url =
        Uri.parse('http://localhost:8080/api/get-events-by-username/$username');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        print('Failed to fetch events: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Event>> getEventsByCategory(String categories) async {
    final url = Uri.parse('$baseUrl/get-all-events-category/$categories');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        print('Failed to fetch events: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Event>> getEventsByAdmin(String username) async {
    final url =
        Uri.parse('http://localhost:8080/api/get-events-for-admin/$username');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        print('Failed to fetch events: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<bool> deleteEvent(Event event) async {
    final url = Uri.parse('http://localhost:8080/api/delete-event');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson2()), // Convert Event to JSON
      );

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

  Future<bool> updateEvent(Event event, String? eventID) async {
    final url = Uri.parse('http://localhost:8080/api/update-event/${eventID}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson2()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('EVENT updated successfully!');
        return true;
      } else {
        print('Failed to updated EVENT: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updated group: $e');
      return false;
    }
  }
    Future<bool> updateMemberRoleInEvent(String userName, String eventId,String role) async {
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
    Future<List<UserReference>> getPendingUsersForEvent(String eventId) async {
    final url = Uri.parse('$baseUrl/get-pending-events-for-admin/$eventId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => UserReference.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load pending users: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching pending users: $e');
    }
  }

  // Approve a user request for an event
  Future<String> approveUserRequest(String eventId, String userId) async {
    final url = Uri.parse(
        '$baseUrl/approve-pending-events-for-admin/$eventId/$userId');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to approve user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error approving user request: $e');
    }
  }

  // Reject a user request for an event
  Future<String> rejectUserRequest(String eventId, String userId) async {
    final url = Uri.parse(
        '$baseUrl/reject-pending-events-for-admin/$eventId/$userId');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to reject user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error rejecting user request: $e');
    }
  }
  Future<List<User>> showMembers(String eventId) async{
      try {
      final response = await http.get(Uri.parse('$baseUrl/get-members-for-events/$eventId'));
      if (response.statusCode == 200) {
        final List<dynamic> members = json.decode(response.body);
        return members.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
Future<List<User>> showAdmins(String eventId) async {
  final url = Uri.parse('$baseUrl/get-admin-for-events/$eventId');
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

    Future<bool> deleteMemberFromEvent(String userName,String eventId) async {
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
}
