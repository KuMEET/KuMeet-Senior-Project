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
  LatLng? initialLocation;
  LatLng? mapCenter;
  Set<Marker> markers = {};
  List<Event> sortedEvents = [];
  PageController pageController = PageController(viewportFraction: 0.8);
  bool isMapInteracting = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation().then((_) => _initializeMarkersAndEvents());
  }

  Future<void> _fetchInitialLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          initialLocation = LatLng(position.latitude, position.longitude);
          mapCenter = initialLocation;
        });
        if (mapController != null && initialLocation != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(initialLocation!, 15),
          );
        }
      } else {
        _showPermissionDeniedDialog(permanentlyDenied: permission == LocationPermission.deniedForever);
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  void _showPermissionDeniedDialog({bool permanentlyDenied = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(permanentlyDenied
            ? 'Location permission is permanently denied. Please enable it in Settings.'
            : 'Location permission is required to use this feature. Please allow it in Settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (permanentlyDenied)
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  void _initializeMarkersAndEvents() {
    if (initialLocation != null) {
      sortedEvents = _sortEventsByDistance(widget.events, initialLocation!);
      _createMarkers();
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
        double distanceA = Geolocator.distanceBetween(location.latitude, location.longitude, a.latitude, a.longitude);
        double distanceB = Geolocator.distanceBetween(location.latitude, location.longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });
  }

  void _onPageChanged(int index) {
    isMapInteracting = false;
    final selectedEvent = sortedEvents[index];
    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(selectedEvent.latitude, selectedEvent.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomGesturesEnabled: true,
                ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180,
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
                      .toStringAsFixed(2);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(
                            event: event,
                            onAddToCalendar: () {},
                            isAdded: false,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                event.imagePath!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text('$distanceKm km away', style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
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
