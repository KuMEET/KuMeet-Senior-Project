import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'event_service.dart';
import 'createEvent_page.dart';
import 'event_card.dart';
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
        categorized[category] =
            events.where((event) => event.categories == category).toList();
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

  // --- ADDED: State for search and filter ---
  String _searchQuery = '';
  String? _selectedCategory;
  bool? _selectedVisibility;
  DateTime? _selectedDate;
  // -----------------------------------------

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

  // --- ADDED: Search and filter handling ---
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _showFilterDialog() {
    // Temporary holders to avoid directly modifying state until "Apply"
    String? tempCategory = _selectedCategory;
    bool? tempVisibility = _selectedVisibility;
    DateTime? tempDate = _selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setTempState) {
            return AlertDialog(
              title: const Text('Filter Events'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: tempCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All'),
                        ),
                        ...widget.categorizedEvents.keys.map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ),
                        ),
                      ],
                      onChanged: (String? val) {
                        setTempState(() {
                          tempCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    // Date picker
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tempDate == null
                                ? 'No date selected'
                                : 'Selected: ${tempDate?.toLocal()}'.split(' ')[0],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: tempDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setTempState(() {
                                tempDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Visibility switch
                    SwitchListTile(
                      title: const Text('Only show visible events'),
                      value: tempVisibility ?? false,
                      onChanged: (bool val) {
                        setTempState(() {
                          tempVisibility = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _selectedVisibility = tempVisibility;
                      _selectedDate = tempDate;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
  // -----------------------------------------

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- UPDATED: Pass callbacks to search and filter --
          SearchAndFilterBar(
            onSearchChanged: _onSearchChanged,
            onFilterPressed: _showFilterDialog,
          ),
          // --------------------------------------------------
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
                      events: widget.categorizedEvents.values
                          .expand((e) => e)
                          .toList(),
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

        // --- ADDED: Filter logic ---
        final filteredEvents = entry.value.where((event) {
          // Search match
          final query = _searchQuery.toLowerCase();
          final titleMatches = event.title.toLowerCase().contains(query);
          final descMatches = event.description.toLowerCase().contains(query);
          final searchMatch = query.isEmpty ? true : (titleMatches || descMatches);

          // Category match
          final categoryMatch =
              _selectedCategory == null || event.categories == _selectedCategory;

          // Visibility match
          final visibilityMatch =
              _selectedVisibility == null || event.visibility == _selectedVisibility;

          // Date match (if user selected a date, we compare by exact day)
          final dateMatch = _selectedDate == null ||
              (event.date != null && _isSameDate(event.date!, _selectedDate!));

          return searchMatch && categoryMatch && visibilityMatch && dateMatch;
        }).toList();
        // --------------------------------

        if (filteredEvents.isEmpty) return const SizedBox.shrink();

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
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
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
  // --- ADDED: We take callbacks for search and filter ---
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;

  const SearchAndFilterBar({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterPressed,
  }) : super(key: key);
  // -----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            // ADDED: handle onChanged
            onChanged: onSearchChanged,
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
          onPressed: onFilterPressed,
        ),
      ],
    );
  }
}

class ExploreFloatingActionButton extends StatelessWidget {
  final Function(Event) onAddEvent;

  const ExploreFloatingActionButton({Key? key, required this.onAddEvent})
      : super(key: key);

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
