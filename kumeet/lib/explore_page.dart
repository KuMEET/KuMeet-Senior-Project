import 'package:flutter/material.dart';
import 'package:kumeet/event_service.dart';
import 'createEvent_page.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'event.dart';
import 'map_view.dart';
import 'owned_events.dart';
import 'owned_groups_page.dart'; // Import OwnedGroupsPage

class ExplorePage extends StatefulWidget {
  final Function(Event) onAddEventToCalendar;
  final bool Function(Event) isEventAdded;

  const ExplorePage({
    super.key,
    required this.onAddEventToCalendar,
    required this.isEventAdded,
  });

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Event> events = [];
  final EventService eventService = EventService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeEvents();
  }

  void initializeEvents() async {
    try {
      final fetchedEvents = await eventService.getEvents();
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $e')),
      );
    }
  }

  void addEvent(Event newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : ExploreBody(
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
    super.key,
    required this.events,
    required this.onAddEventToCalendar,
    required this.isEventAdded,
  });

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapView(events: events),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text('Go to Map View'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OwnedEventsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text('Go to Owned Events'),
            ),
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
  const SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Events • Koç University',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
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

  const ExploreFloatingActionButton({super.key, required this.onAddEvent});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Navigate to OwnedGroupsPage to select a group first
        final selectedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OwnedGroupsPage()),
        );

        if (selectedGroup != null) {
          // After selecting a group, navigate to CreateEventPage
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventPage(selectedGroup: selectedGroup),
            ),
          ) as Event?;

          if (newEvent != null) {
            onAddEvent(newEvent); // Add the event to the list
          }
        }
      },
      backgroundColor: Colors.deepOrange,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
