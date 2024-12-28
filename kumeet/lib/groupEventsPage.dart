import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/eventDetail_page.dart';
import 'package:kumeet/group_service.dart';
import 'group.dart';

class GroupEventsPage extends StatefulWidget {
  final Group group;

  const GroupEventsPage({Key? key, required this.group}) : super(key: key);

  @override
  _GroupEventsPageState createState() => _GroupEventsPageState();
}

class _GroupEventsPageState extends State<GroupEventsPage> {
  Group get _group => widget.group; // Corrected the recursive getter issue.

  Future<List<Event>> _getEventsForGroup() async {
    GroupService groupService = GroupService();
    try {
      return await groupService.getEventsforGroups(_group);
    } catch (e) {
      throw Exception('Failed to fetch events: $e'); // Better error handling
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
        title: Text('Events for ${_group.name}'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _getEventsForGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Clear error display
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
