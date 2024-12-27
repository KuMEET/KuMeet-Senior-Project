import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/login_page.dart';
import 'package:kumeet/main.dart';
import 'map_picker_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'event.dart';
import 'event_service.dart';

class CreateEventPage extends StatefulWidget {
  final Group selectedGroup;

  const CreateEventPage({super.key, required this.selectedGroup});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _seatsController = TextEditingController();
  LatLng? _eventLocation;
  DateTime? _selectedDate;
  String? _selectedCategory;
  String? UserName = GlobalState().userName;
  final EventService eventService = EventService();
  final GroupService groupService = GroupService();
  bool _isVisible = true;

  // Event categories
  final List<String> _categories = [
    "Art & Culture",
    "Career & Business",
    "Dancing",
    "Games",
    "Music",
    "Science & Education",
    "Identity & Language",
    "Social Activities",
    "Sports & Fitness",
    "Travel & Outdoor",
  ];

  Future<void> _pickLocation() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );
    if (pickedLocation != null) {
      setState(() {
        _eventLocation = pickedLocation;
      });
    }
  }

  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_eventLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }

      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final newEvent = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        location: 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
        latitude: _eventLocation!.latitude,
        longitude: _eventLocation!.longitude,
        seatsAvailable: int.parse(_seatsController.text),
        date: _selectedDate!,
        imagePath: 'images/event_image.png',
        visibility: _isVisible,
        categories: _selectedCategory!,
      );

      final success = await eventService.createEvent(newEvent, UserName!);
      if (success) {
        final getEvents = await eventService.getEventsByUser(UserName!);
        for (var event in getEvents){
          if(event.title == newEvent.title && event.description == newEvent.description){
          final binding = await groupService.addEventToGroup(widget.selectedGroup, event);
          break;
          }
        }
          
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
              // Navigate to the ExplorePage
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create event.')),
        );
      }
    }
  }

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
        title: const Text('Create Event', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
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
              // Title field
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
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              // Description field
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
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              // Seats Available field
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
              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Event Category',
                  prefixIcon: const Icon(Icons.category, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              // Location picker button
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
              // Date picker row
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
                    child: const Text('Pick Date', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Visibility toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Event Visibility', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: _isVisible,
                    onChanged: (value) {
                      setState(() {
                        _isVisible = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Create Event button
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
