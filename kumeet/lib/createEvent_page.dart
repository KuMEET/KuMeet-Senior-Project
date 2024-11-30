import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:latlong2/latlong.dart'; // For LatLng
import 'map_picker_page.dart'; // Import the map picker
import 'event.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _seatsController = TextEditingController();
  LatLng? _eventLocation; // Holds the picked location
  DateTime? _selectedDate; // Holds the selected date

  // Function to pick a location
  Future<void> _pickLocation() async {
    final pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    ) as LatLng?;
    if (pickedLocation != null) {
      setState(() {
        _eventLocation = pickedLocation;
      });
    }
  }

  // Function to create an event
  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      if (_eventLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }

      final newEvent = Event(
        imagePath: 'images/event_image.png',
        title: _titleController.text,
        description: _descriptionController.text,
        location: 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
        seatsAvailable: int.parse(_seatsController.text),
        date: _selectedDate,
        latitude: _eventLocation!.latitude,
        longitude: _eventLocation!.longitude,
      );

      Navigator.pop(context, newEvent); // Return the event to the previous screen
    }
  }

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Event',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // Black app bar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900], // Dark background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  prefixIcon: const Icon(Icons.title, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Event Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  prefixIcon: const Icon(Icons.description, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),

              // Number of Seats
              TextFormField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Seats Available',
                  prefixIcon: const Icon(Icons.event_seat, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || int.tryParse(value) == null
                    ? 'Please enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16),

              // Location Picker
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLocation,
                    child: const Text('Pick Location'),
                  ),
                  const SizedBox(width: 16),
                  if (_eventLocation != null)
                    Expanded(
                      child: Text(
                        'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
                        style: const TextStyle(color: Colors.teal),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Picker
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate == null
                        ? 'Select Event Date'
                        : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text(
                      'Pick Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Create Event Button
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
