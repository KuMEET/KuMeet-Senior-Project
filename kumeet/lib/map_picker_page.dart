import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({Key? key}) : super(key: key);

  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;
  final LatLng _defaultLocation = LatLng(41.0082, 28.9784); // Istanbul

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Event Location'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // FlutterMap widget for OpenStreetMap
          FlutterMap(
            options: MapOptions(
              
              onTap: (tapPosition, point) {
              center: _pickedLocation ?? _defaultLocation; // Use picked or default location
              zoom: 13.0; // Initial zoom level
              maxZoom: 18.0; // Maximum zoom level
                setState(() {
                  _pickedLocation = point; // Update picked location
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    
                  ],
                ),
            ],
          ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _pickedLocation); // Return picked location
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Location',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
