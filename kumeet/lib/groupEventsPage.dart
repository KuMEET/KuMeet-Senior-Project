import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/event.dart';
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
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  void _onAddToCalendar(Event event) {
    setState(() {
      // Logic to handle adding the event to calendar, if needed.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${widget.group.name}'),
      ),
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
                          isAdded: false, // Adjust as needed
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (event.date != null)
                            Text(
                              DateFormat.yMMMMd().format(event.date!),
                              style: const TextStyle(fontSize: 14),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            event.location,
                            style: const TextStyle(fontSize: 14),
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
