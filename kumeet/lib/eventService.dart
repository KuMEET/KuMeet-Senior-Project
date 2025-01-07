import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kumeet/event.dart';
import 'package:kumeet/user.dart';
import 'package:kumeet/userReference.dart';
import 'package:path/path.dart' as p;  // For filename utilities

class EventService {
  late final String baseUrl;

  EventService() {
    // Determine the base URL based on the platform
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator uses 10.0.2.2 for localhost
    } else if (Platform.isIOS) {
      baseUrl = 'http://localhost:8080/api'; // iOS simulator uses localhost
    } else {
      baseUrl = 'http://localhost:8080/api'; // macOS, web, etc.
    }
  }

  // Method to create an event
  Future<bool> createEvent(Event event, String username, File? imageFile) async {
    // If no image is provided, you can decide what to do.
    if (imageFile == null) {
      print("No image selected for this event.");
      // Depending on your backend logic, it might fail or you might skip
      // the photo param. For now, we’ll fail:
      return false;
    }
    try {
      final uri = Uri.parse('$baseUrl/create-event/$username');
      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add all fields that match @ModelAttribute EventDto
      // (they must have the same names as in your EventDto)
      request.fields['title']       = event.title;
      request.fields['description'] = event.description;
      request.fields['latitude']    = event.latitude.toString();
      request.fields['longitude']   = event.longitude.toString();
      request.fields['capacity']    = event.seatsAvailable.toString();
      // Make sure to format the date the same way your backend expects
      request.fields['time']        = event.date?.toIso8601String() ?? '';
      request.fields['visibility']  = event.visibility.toString();
      request.fields['categories']  = event.categories;

      // If you want to send groupID as well, make sure your backend's DTO can handle it
      if (event.groupID != null) {
        request.fields['groupID'] = event.groupID!;
      }

      // Add file (photo) -> must match @RequestParam("photo")
      final fileName = p.basename(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',            // <-- the 'name' must match @RequestParam("photo")
          imageFile.path,
          filename: fileName, // or you can do "event_${DateTime.now().millisecondsSinceEpoch}.jpg"
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        print('Event created successfully with image!');
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
        Uri.parse('$baseUrl/get-events-by-username/$username');
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
  Future<List<Event>> getEventsByUserMembers(String username) async {
    final url =
        Uri.parse('$baseUrl/get-events-by-username-only-members/$username');
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
        Uri.parse('$baseUrl/get-events-for-admin/$username');
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
    final url = Uri.parse('$baseUrl/delete-event');
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
    final url = Uri.parse('$baseUrl/update-event/${eventID}');
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
    final url = Uri.parse('$baseUrl/approve-pending-events-for-admin/$eventId/$userId');
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
    final url = Uri.parse('$baseUrl/reject-pending-events-for-admin/$eventId/$userId');
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
  final url = Uri.parse('$baseUrl/get-admins-for-event/$eventId');
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
