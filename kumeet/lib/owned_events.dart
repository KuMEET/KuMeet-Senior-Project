import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'event.dart';
import 'event_service.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';

class OwnedEventsPage extends StatefulWidget {
  const OwnedEventsPage({super.key});

  @override
  _OwnedEventsPageState createState() => _OwnedEventsPageState();
}

class _OwnedEventsPageState extends State<OwnedEventsPage> {
  List<Event> ownedEvents = [];
  bool isLoading = true;
  final EventService eventService = EventService();
  String? UserName = GlobalState().userName;
  @override
  void initState() {
    super.initState();
    fetchOwnedEvents();
  }

  Future<void> fetchOwnedEvents() async {
    try {
      // Replace with your method to fetch owned events
      final events = await eventService.getEventsByUser(UserName!);
      setState(() {
        ownedEvents = events;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load owned events: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owned Events'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : ownedEvents.isEmpty
              ? const Center(
                  child: Text(
                    'No owned events found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: ownedEvents.length,
                  itemBuilder: (context, index) {
                    final event = ownedEvents[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: EventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailPage(
                                event: event,
                                onAddToCalendar: () {},
                                isAdded: true,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
