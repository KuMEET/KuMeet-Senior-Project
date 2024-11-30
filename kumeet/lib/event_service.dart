import 'dart:convert';
import 'package:http/http.dart' as http;
import 'event.dart';

class EventService {
  final String baseUrl = 'http://localhost:8080/api';


  Future<bool> createEvent(Event event) async {
    final url = Uri.parse('$baseUrl/api/events');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
}
