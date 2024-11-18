import 'package:flutter/material.dart';
import 'createEvent_page.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'event.dart';

class ExplorePage extends StatefulWidget {
  final Function(Event) onAddEventToCalendar;
  final bool Function(Event) isEventAdded;

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
    initializeEvents();
  }

  void initializeEvents() {
    events.addAll([
      Event(
        imagePath: 'images/event_image.png',
        title: 'Speakers! Mini Conference!',
        description: 'An engaging session with industry leaders sharing insights.',
        location: 'Online',
        seatsAvailable: 100,
        date: DateTime.now().add(Duration(days: 1)),
      ),
      Event(
        imagePath: 'images/event_image.png',
        title: 'Exandria: Threads of Fate',
        description: 'A regular tabletop RPG game for fantasy enthusiasts.',
        location: 'Golem\'s Gate - Gaming & Geekdom',
        seatsAvailable: 10,
        date: DateTime.now().add(Duration(days: 14)),
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
      body: ExploreBody(
        events: events,
        onAddEventToCalendar: widget.onAddEventToCalendar,
        isEventAdded: widget.isEventAdded,
      ),
      floatingActionButton: ExploreFloatingActionButton(
        onAddEvent: (Event newEvent) => addEvent(newEvent),
      ),
    );
  }
}


class ExploreBody extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onAddEventToCalendar;
  final bool Function(Event) isEventAdded;

  const ExploreBody({
    Key? key,
    required this.events,
    required this.onAddEventToCalendar,
    required this.isEventAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchAndFilterBar(),
            const SizedBox(height: 16),
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
                            onAddEventToCalendar(event);
                            Navigator.pop(context);
                          },
                          isAdded: isEventAdded(event),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SearchAndFilterBar extends StatelessWidget {
  const SearchAndFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: () {
            // Add filter functionality
          },
        ),
      ],
    );
  }
}

class ExploreFloatingActionButton extends StatelessWidget {
  final Function(Event) onAddEvent;

  const ExploreFloatingActionButton({Key? key, required this.onAddEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final newEvent = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateEventPage()),
        ) as Event?;
        if (newEvent != null) {
          onAddEvent(newEvent);
        }
      },
      backgroundColor: const Color.fromARGB(255, 255, 120, 53),
      child: const Icon(Icons.add, color: Colors.white,),
    );
  }
}
