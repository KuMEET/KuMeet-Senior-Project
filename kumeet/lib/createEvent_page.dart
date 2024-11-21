import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:latlong2/latlong.dart'; // For LatLng
import 'map_picker_page.dart'; // Import the map picker
import 'event.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

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
  void _pickLocation() async {
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
      );

      Navigator.pop(context, newEvent);
    }
  }

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
<<<<<<< HEAD
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
=======
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime.now(), // Set the earliest selectable date
      lastDate: DateTime(2100), // Set the latest selectable date
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
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
      backgroundColor: Colors.grey[900], 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
<<<<<<< HEAD
              // Event Title
=======
              // Event Title Field
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
<<<<<<< HEAD
                  prefixIcon: const Icon(Icons.title, color: Colors.teal),
=======
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.title, color: Colors.white),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
                  filled: true,
                  fillColor: Colors.grey[800], // Darker grey for input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
<<<<<<< HEAD
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Event Description
=======
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for the event';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Description Field
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
<<<<<<< HEAD
                  prefixIcon: const Icon(Icons.description, color: Colors.teal),
=======
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.description, color: Colors.white),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
<<<<<<< HEAD
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),

              // Number of Seats
=======
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description for the event';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Seats Available Field
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
              TextFormField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
<<<<<<< HEAD
                  labelText: 'Seats Available',
                  prefixIcon: const Icon(Icons.event_seat, color: Colors.teal),
=======
                  labelText: 'Number of Seats Available',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.event_seat, color: Colors.white),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
<<<<<<< HEAD
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
=======
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify the number of seats available';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Event Location',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a location for the event';
                  }
                  return null;
                },
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
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
<<<<<<< HEAD
=======
                    style: const TextStyle(color: Colors.white),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
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
<<<<<<< HEAD
                child: const Text('Create Event'),
=======
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
              ),
            ],
          ),
        ),
      ),
    );
  }
}
