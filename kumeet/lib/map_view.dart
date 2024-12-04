import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'event.dart';
import 'eventDetail_page.dart';

class MapView extends StatefulWidget {
  final List<Event> events;

  const MapView({super.key, required this.events});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  LatLng? initialLocation; // Initial user location
  LatLng? mapCenter; // Current center of the map
  Set<Marker> markers = {};
  List<Event> sortedEvents = [];
  PageController pageController = PageController(viewportFraction: 0.8);
  bool isMapInteraction = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation().then((_) {
      _initializeMarkersAndEvents();
    });
  }

  Future<void> _fetchInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        initialLocation = LatLng(position.latitude, position.longitude);
        mapCenter = initialLocation; // Set map center to user's location
      });
      if (mapController != null && initialLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(initialLocation!, 15),
        );
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  void _initializeMarkersAndEvents() {
    if (initialLocation != null) {
      sortedEvents = _sortEventsByDistance(widget.events, initialLocation!);

      for (var event in sortedEvents) {
        markers.add(
          Marker(
            markerId: MarkerId(event.title),
            position: LatLng(event.latitude, event.longitude),
            infoWindow: InfoWindow(title: event.title),
            onTap: () {
              pageController.animateToPage(
                sortedEvents.indexOf(event),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        );
      }
      setState(() {});
    }
  }

  List<Event> _sortEventsByDistance(List<Event> events, LatLng location) {
    return events
        .map((event) => {
              "event": event,
              "distance": Geolocator.distanceBetween(
                location.latitude,
                location.longitude,
                event.latitude,
                event.longitude,
              ),
            })
        .toList()
        .map((map) => map["event"] as Event)
        .toList()
        ..sort((a, b) => (Geolocator.distanceBetween(
                  location.latitude,
                  location.longitude,
                  a.latitude,
                  a.longitude,
                ) -
                Geolocator.distanceBetween(
                  location.latitude,
                  location.longitude,
                  b.latitude,
                  b.longitude,
                ))
            .toInt());
  }

  void _onMapMoved() async {
    if (isMapInteraction && mapController != null) {
      LatLng center = await mapController!.getLatLng(ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ));
      setState(() {
        mapCenter = center; // Update map center
        sortedEvents = _sortEventsByDistance(widget.events, mapCenter!);
      });
    }
  }

  void _onPageChanged(int index) {
    isMapInteraction = false; // Stop map interaction logic during card swipe
    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(sortedEvents[index].latitude, sortedEvents[index].longitude),
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
                    isMapInteraction = true; // Enable map interaction
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
                                Text(
                                  "${Geolocator.distanceBetween(
                                        mapCenter?.latitude ?? 0,
                                        mapCenter?.longitude ?? 0,
                                        event.latitude,
                                        event.longitude,
                                      ).toStringAsFixed(0)} meters away",
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
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
