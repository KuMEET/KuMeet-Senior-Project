import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'event_service.dart';
import 'createEvent_page.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'event.dart';
import 'map_view.dart';
import 'owned_groups_page.dart';

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
  final EventService eventService = EventService();
  final List<String> categories = [
    "ART_CULTURE",
    "CAREER_BUSINESS",
    "DANCING",
    "GAMES",
    "MUSIC",
    "SCIENCE_EDUCATION",
    "IDENTITY_LANGUAGE",
    "SOCIAL_ACTIVITIES",
    "SPORTS_FITNESS",
    "TRAVEL_OUTDOOR",
  ];

  final Map<String, List<Event>> categorizedEvents = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  Future<void> _fetchAllEvents() async {
    try {
      final events = await eventService.getEvents();
      final Map<String, List<Event>> categorized = {};

      for (var category in categories) {
        categorized[category] = events.where((event) => event.categories == category).toList();
      }

      setState(() {
        categorizedEvents.addAll(categorized);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ExploreBody(
              categorizedEvents: categorizedEvents,
              onAddEventToCalendar: widget.onAddEventToCalendar,
              isEventAdded: widget.isEventAdded,
            ),
      floatingActionButton: ExploreFloatingActionButton(
        onAddEvent: (Event newEvent) {
          setState(() {
            categorizedEvents[newEvent.categories]?.add(newEvent);
          });
        },
      ),
    );
  }
}

class ExploreBody extends StatefulWidget {
  final Map<String, List<Event>> categorizedEvents;
  final Function(Event) onAddEventToCalendar;
  final bool Function(Event) isEventAdded;

  const ExploreBody({
    Key? key,
    required this.categorizedEvents,
    required this.onAddEventToCalendar,
    required this.isEventAdded,
  }) : super(key: key);

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
          buildMapView(),
          const SizedBox(height: 16),
          buildCategorySections(),
        ],
      ),
    );
  }

  Widget buildMapView() {
    return SizedBox(
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
                    markers: widget.categorizedEvents.values
                        .expand((events) => events)
                        .map(
                          (event) => Marker(
                            markerId: MarkerId(event.id ?? event.title),
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
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapView(
                      events: widget.categorizedEvents.values.expand((e) => e).toList(),
                    ),
                  ),
                );
              },
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySections() {
    return Column(
      children: widget.categorizedEvents.entries.map((entry) {
        final category = entry.key;
        final events = entry.value;

        if (events.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
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
              hintText: 'Search Events • Koç University',
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

  const ExploreFloatingActionButton({Key? key, required this.onAddEvent}) : super(key: key);

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
