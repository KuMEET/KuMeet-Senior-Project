import 'dart:convert';
import 'package:http/http.dart' as http;
import 'event.dart';

class EventService {
  final String baseUrl = 'http://localhost:8080/api';

  // Method to create an event
  Future<bool> createEvent(Event event) async {
    final url = Uri.parse('$baseUrl/create-event');
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
}
