import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/event_service.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/login_page.dart';
import 'package:kumeet/main.dart';
import 'map_picker_page.dart';

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
  String? userName = GlobalState().userName; // Ensure this is correctly initialized
  final EventService eventService = EventService();
  final GroupService groupService = GroupService();
  bool _isVisible = true;

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
        groupID: widget.selectedGroup.id!,
      );
      final success = await eventService.createEvent(newEvent, userName!);
      if (success) {
        final createdEvents = await eventService.getEvents();
        for(var event in createdEvents){
          if(event.title == newEvent.title && event.description == newEvent.description){
            final binding = await groupService.addEventToGroup(widget.selectedGroup.id!, event.id!);
            if(binding){
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
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
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a title';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a description';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Seats Available',
                  prefixIcon: const Icon(Icons.event_seat),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Event Category',
                  prefixIcon: const Icon(Icons.category),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categories.map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLocation,
                    child: const Text('Pick Location'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _eventLocation == null ? 'No location selected' : 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate == null ? 'Select Event Date' : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Event Visibility'),
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
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
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
