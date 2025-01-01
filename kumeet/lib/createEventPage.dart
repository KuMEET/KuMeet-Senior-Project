import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:kumeet/event.dart';
import 'package:kumeet/eventService.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/groupService.dart';
import 'package:kumeet/loginPage.dart';
import 'package:kumeet/main.dart';
import 'mapPickerPage.dart';

class CreateEventPage extends StatefulWidget {
  final Group selectedGroup;

  const CreateEventPage({super.key, required this.selectedGroup});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _seatsController       = TextEditingController();

  LatLng? _eventLocation;
  DateTime? _selectedDate;
  String?   _selectedCategory;
  bool      _isVisible = true;

  // Address fetched from Google Geocoding
  String? _fetchedAddress;

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

  String? userName = GlobalState().userName;
  final EventService eventService = EventService();
  final GroupService groupService = GroupService();

  // This will store the file (picked image) locally
  File? _pickedImageFile;

  // Called to pick an image (from gallery)
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Called to pick the event location on map
  Future<void> _pickLocation() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );
    if (pickedLocation != null) {
      setState(() {
        _eventLocation = pickedLocation;
      });
      // After setting location, fetch the formatted address
      await _fetchAddress(pickedLocation.latitude, pickedLocation.longitude);
    }
  }

  // Use Google Geocoding to fetch address
  Future<void> _fetchAddress(double lat, double lng) async {
    const String mapApiKey = 'AIzaSyAvvTbatpuGGLbXK0BFESM8IiMVXmlzIws';
    final String host = 'https://maps.googleapis.com/maps/api/geocode/json';
    final String url = '$host?key=$mapApiKey&language=en&latlng=$lat,$lng';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map data = jsonDecode(response.body);
        if (data["results"] != null && data["results"].isNotEmpty) {
          setState(() {
            _fetchedAddress = data["results"][0]["formatted_address"];
          });
        } else {
          setState(() {
            _fetchedAddress = "No address found at this location.";
          });
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        _fetchedAddress = "Error fetching address!";
      });
    }
  }

  // Called to pick the date
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

  // Create event method (includes image upload)
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

      // If picking an image is mandatory, check that:
      if (_pickedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick an image')),
        );
        return;
      }

      final newEvent = Event(
        title:         _titleController.text,
        description:   _descriptionController.text,
        location:      _fetchedAddress ?? 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
        latitude:      _eventLocation!.latitude,
        longitude:     _eventLocation!.longitude,
        seatsAvailable: int.parse(_seatsController.text),
        date:          _selectedDate!,
        imagePath:     'images/event_image.png', // fallback
        visibility:    _isVisible,
        categories:    _selectedCategory!,
        groupID:       widget.selectedGroup.id!,
      );

      final success = await eventService.createEvent(newEvent, userName!, _pickedImageFile);

      if (success) {
        // Optionally add the event to the group
        final createdEvents = await eventService.getEvents();
        for (var event in createdEvents) {
          if (event.title == newEvent.title && event.description == newEvent.description) {
            final binding = await groupService.addEventToGroup(widget.selectedGroup.id!, event.id!);
            if (binding) {
              print("Event bound to the group successfully.");
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
              // Event Title
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Description
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Seats
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
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
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
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Pick location
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLocation,
                    child: const Text('Pick Location'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _eventLocation == null
                            ? 'No location selected'
                            : 'Location selected:',
                        ),
                        if (_fetchedAddress != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _fetchedAddress!,
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pick date
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate == null
                        ? 'Select Event Date'
                        : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Visibility Switch
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
              const SizedBox(height: 16),

              // Image box (tap to pick)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: _pickedImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _pickedImageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Tap to select an image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Create Event button
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
