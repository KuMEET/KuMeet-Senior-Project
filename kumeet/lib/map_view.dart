import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'event.dart';

class MapView extends StatefulWidget {
  final List<Event> events;

  const MapView({Key? key, required this.events}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? mapController; // Changed to nullable
  LatLng currentLocation = const LatLng(41.01384, 28.94966); // Default location
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _getCurrentLocation();
  }

  void _initializeMarkers() {
    // Create markers for all events
    for (var event in widget.events) {
      markers.add(
        Marker(
          markerId: MarkerId(event.title),
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(title: event.title),
          onTap: () {
            _showEventPreview(event);
          },
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  void _showEventPreview(Event event) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(event.description),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 15,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller; // Initialize the mapController here
        },
        myLocationEnabled: true,
      ),
    );
  }
}
