import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/event.dart'; // Ensure your Event class is imported here
import 'package:kumeet/eventDetail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'group.dart';

class GroupEventsPage extends StatefulWidget {
  final Group group;

  const GroupEventsPage({super.key, required this.group});

  @override
  _GroupEventsPageState createState() => _GroupEventsPageState();
}

class _GroupEventsPageState extends State<GroupEventsPage> {
  Future<List<Event>> _getEventsForGroup() async {
    try {
      final url = Uri.parse('http://localhost:8080/api/events/${widget.group.id}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((event) => Event.fromJson(event)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  void _onAddToCalendar(Event event) {
    // Logic to handle adding event to calendar
    // This might update the UI or call an API, based on your needs
    setState(() {
      // Handle the logic for when the event is successfully added
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Events for ${widget.group.name}'),
      ),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<Event>>(
        future: _getEventsForGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events available.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          event: event,
                          onAddToCalendar: () => _onAddToCalendar(event),
                          isAdded: false, // Assume false, you can modify based on actual state
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Title
                          Text(
                            event.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          // Event Date
                          if (event.date != null)
                            Text(
                              DateFormat.yMMMMd().format(event.date!),
                              style: const TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          const SizedBox(height: 8),
                          // Event Location
                          Text(
                            event.location,
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
