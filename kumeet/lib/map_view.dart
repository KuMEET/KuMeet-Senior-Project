import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'event.dart';
import 'eventDetail_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MapView extends StatefulWidget {
  final List<Event> events;

  const MapView({super.key, required this.events});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  LatLng? initialLocation; // User's initial location
  LatLng? mapCenter; // Current center of the map
  Set<Marker> markers = {};
  List<Event> sortedEvents = []; // Initial order sorted by user location
  PageController pageController = PageController(viewportFraction: 0.8);
  bool isMapInteracting = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation().then((_) => _initializeMarkersAndEvents());
  }

Future<void> _fetchInitialLocation() async {
  try {
    var status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        initialLocation = LatLng(position.latitude, position.longitude);
        mapCenter = initialLocation; // Set map center to user's location
      });
      if (mapController != null && initialLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(initialLocation!, 15),
        );
      }
    } else if (status.isDenied) {
      debugPrint('Location permission denied.');
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      debugPrint('Location permission permanently denied.');
      await openAppSettings(); // Prompt the user to enable permissions in settings
    }
  } catch (e) {
    debugPrint('Error fetching location: $e');
  }
}
void _showPermissionDeniedDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Permission Denied'),
      content: const Text(
          'Location permission is required to use this feature. Please enable it in Settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}

  void _initializeMarkersAndEvents() {
    if (initialLocation != null) {
      // Sort events by distance from the user's initial location
      sortedEvents = _sortEventsByDistance(widget.events, initialLocation!);
      _createMarkers(); // Add markers based on the sorted events
      setState(() {});
    }
  }

  void _createMarkers() {
    markers.clear();
    for (var event in sortedEvents) {
      markers.add(
        Marker(
          markerId: MarkerId(event.title),
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(title: event.title),
          onTap: () {
            // Navigate to the respective card when tapping a marker
            pageController.animateToPage(
              sortedEvents.indexOf(event),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      );
    }
  }

  List<Event> _sortEventsByDistance(List<Event> events, LatLng location) {
    return List.from(events)
      ..sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          a.latitude,
          a.longitude,
        );
        double distanceB = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
  }

  void _onMapMoved() async {
    if (isMapInteracting && mapController != null) {
      LatLng center = await mapController!.getLatLng(ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ));
      setState(() {
        mapCenter = center; // Update map center
      });
      _highlightClosestEvent(center);
    }
  }

  void _highlightClosestEvent(LatLng center) {
    int closestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < sortedEvents.length; i++) {
      final event = sortedEvents[i];
      final distance = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        event.latitude,
        event.longitude,
      );
      if (distance < minDistance) {
        closestIndex = i;
        minDistance = distance;
      }
    }

    // Highlight the closest event without reordering
    pageController.animateToPage(
      closestIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    isMapInteracting = false; // Stop map interaction logic during card swipe
    final selectedEvent = sortedEvents[index];
    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(selectedEvent.latitude, selectedEvent.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          initialLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialLocation!,
                    zoom: 15,
                  ),
                  markers: markers,
                  onMapCreated: (controller) => mapController = controller,
                  onCameraMoveStarted: () {
                    isMapInteracting = true; // Enable map interaction
                  },
                  onCameraIdle: _onMapMoved,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomGesturesEnabled: true,
                ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180, // Adjusted height to show 1.5 cards
              child: PageView.builder(
                controller: pageController,
                itemCount: sortedEvents.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final event = sortedEvents[index];
                  final distanceKm = (Geolocator.distanceBetween(
                            initialLocation?.latitude ?? 0,
                            initialLocation?.longitude ?? 0,
                            event.latitude,
                            event.longitude,
                          ) /
                          1000)
                      .toStringAsFixed(2); // Convert meters to km
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(
                            event: event,
                            onAddToCalendar: () {}, // Add your callback logic
                            isAdded: false, // Replace with your condition
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // Added padding
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                event.imagePath,
                                width: 100, // Square image size
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("$distanceKm km away"),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
