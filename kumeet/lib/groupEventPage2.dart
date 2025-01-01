import 'package:flutter/material.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/eventDetailPage2.dart';  // Assuming this page exists and is similar to EventDetailPage
import 'package:kumeet/groupService.dart';
import 'package:kumeet/group.dart';
import 'eventCard.dart'; // Ensure this import points to your EventCard definition file

class GroupEventsPage2 extends StatefulWidget {
  final Group group;

  const GroupEventsPage2({Key? key, required this.group}) : super(key: key);

  @override
  _GroupEventsPage2State createState() => _GroupEventsPage2State();
}

class _GroupEventsPage2State extends State<GroupEventsPage2> {
  Future<List<Event>> _getEventsForGroup() async {
    GroupService groupService = GroupService();
    try {
      return await groupService.getEventsforGroups(widget.group);
    } catch (e) {
      print('Failed to fetch events: $e');
      throw Exception('Failed to fetch events: $e');
    }
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
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage2(event: event, onEventUpdated: () {  }, onEventDeleted: () {  },),
                      ),
                    );
                  },
                  cardWidth: MediaQuery.of(context).size.width - 32, // Adapt card width to screen
                );
              },
            );
          }
        },
      ),
    );
  }
}
