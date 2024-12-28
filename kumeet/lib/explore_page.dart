import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kumeet/event_service.dart';
import 'createEvent_page.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'event.dart';
import 'map_view.dart';
import 'owned_events.dart';
import 'owned_groups_page.dart';

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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

class ExploreBody extends StatefulWidget {
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
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('Error fetching user location: $e');
      setState(() {
        userLocation = const LatLng(41.0082, 28.9784); // Default to Istanbul
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchAndFilterBar(),
          const SizedBox(height: 16),
          // Small Map Section with Clickable Overlay
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: userLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: userLocation!,
                            zoom: 10,
                          ),
                          markers: widget.events
                              .map(
                                (event) => Marker(
                                  markerId: MarkerId(event.title),
                                  position: LatLng(event.latitude, event.longitude),
                                  infoWindow: InfoWindow(title: event.title),
                                ),
                              )
                              .toSet(),
                          zoomGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                ),
                // Transparent overlay for tap detection
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      // Debug: Check if tap is detected
                      debugPrint('Map tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapView(events: widget.events),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent, // Fully transparent overlay
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (var event in widget.events)
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
                          widget.onAddEventToCalendar(event);
                          Navigator.pop(context);
                        },
                        isAdded: widget.isEventAdded(event),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
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
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.filter_list),
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
        final selectedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OwnedGroupsPage()),
        );

        if (selectedGroup != null) {
          final newEvent = await Navigator.push<Event>(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventPage(selectedGroup: selectedGroup),
            ),
          );
          if (newEvent != null) {
            onAddEvent(newEvent);
          }
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
