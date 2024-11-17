import 'package:flutter/material.dart';
import 'createEvent_page.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'event.dart';

class ExplorePage extends StatefulWidget {
  final Function(Event) onAddEventToCalendar; // Callback to add event to calendar
  final bool Function(Event) isEventAdded; // Callback to check if event is already added

  const ExplorePage({
    Key? key,
    required this.onAddEventToCalendar,
    required this.isEventAdded,
  }) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    // Initialize with some default events
    events.addAll([
      Event(
        imagePath: 'images/event_image.png',
        title: 'Speakers! Mini Conference!',
        description: 'An engaging session with industry leaders sharing insights.',
        location: 'Online',
        seatsAvailable: 100,
        date: DateTime.now().add(Duration(days: 1)), // Example date: tomorrow
      ),
      Event(
        imagePath: 'images/event_image.png',
        title: 'Exandria: Threads of Fate',
        description: 'A regular tabletop RPG game for fantasy enthusiasts.',
        location: 'Golem\'s Gate - Gaming & Geekdom',
        seatsAvailable: 10,
        date: DateTime.now().add(Duration(days: 14)), // Example date: two weeks from now
      ),
    ]);
  }

  void addEvent(Event newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Events'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Events • Koç University',
                        prefixIcon: const Icon(Icons.search),
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display events as EventCards
              for (var event in events)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: EventCard(
                    event: event,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(
                            event: event,
                            onAddToCalendar: () {
                              widget.onAddEventToCalendar(event); // Add event to calendar
                              Navigator.pop(context); // Return to ExplorePage after adding
                            },
                            isAdded: widget.isEventAdded(event), // Check if event is already added
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEventPage()),
          ) as Event?;
          if (newEvent != null && mounted) {
            addEvent(newEvent);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
