import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package for date formatting
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
  final _locationUrlController = TextEditingController();
  DateTime? _selectedDate; // Holds the selected date

  double? latitude;
  double? longitude;

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        imagePath: 'images/event_image.png', // Default image path
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationUrlController.text,
        seatsAvailable: int.parse(_seatsController.text),
        date: _selectedDate,
        latitude: latitude!,
        longitude: longitude!,
      );
      Navigator.pop(context, newEvent); // Return the new event to the previous screen
    }
  }

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime.now(), // Set the earliest selectable date
      lastDate: DateTime(2100), // Set the latest selectable date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Extract latitude and longitude from Google Maps URL
  void _extractCoordinates(String url) {
    final regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)'); // Matches @latitude,longitude
    final match = regex.firstMatch(url);
    if (match != null) {
      latitude = double.parse(match.group(1)!);
      longitude = double.parse(match.group(2)!);
    } else {
      latitude = null;
      longitude = null;
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
              // Event Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.title, color: Colors.white),
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
                    return 'Please enter a title for the event';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.description, color: Colors.white),
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
                    return 'Please provide a description for the event';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Seats Available Field
              TextFormField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Seats Available',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.event_seat, color: Colors.white),
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
                    return 'Please specify the number of seats available';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Google Maps URL Field
              TextFormField(
                controller: _locationUrlController,
                decoration: InputDecoration(
                  labelText: 'Google Maps URL',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.map, color: Colors.white),
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
                    return 'Please provide a Google Maps URL';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Please provide a valid URL';
                  }
                  _extractCoordinates(value);
                  if (latitude == null || longitude == null) {
                    return 'Invalid Google Maps URL. Ensure it contains coordinates.';
                  }
                  return null;
                },
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
                    style: const TextStyle(color: Colors.white),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
