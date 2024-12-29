import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Use this LatLng
import 'package:kumeet/map_picker_page.dart';
import 'event.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  final Function(Event updatedEvent) onEventUpdated;

  const EditEventPage({
    Key? key,
    required this.event,
    required this.onEventUpdated,
  }) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _capacityController;
  bool _isLoading = false;
  LatLng? _eventLocation;
  DateTime? _selectedDate;

  // Predefined categories (display strings)
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

  // Currently selected display category
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _capacityController = TextEditingController(
      text: widget.event.seatsAvailable.toString(),
    );
    _eventLocation = LatLng(widget.event.latitude, widget.event.longitude);
    _selectedDate = widget.event.date;

    // Initialize the dropdown with the event's current category
    // Make sure widget.event.categories is one of the items in _categories
    if (_categories.contains(widget.event.categories)) {
      _selectedCategory = widget.event.categories;
    } else {
      // If the event's category doesn't match any display strings,
      // you may either set it to null or handle it in your own way:
      _selectedCategory = null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickLocation() async {
    final pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );
    if (pickedLocation != null) {
      setState(() {
        _eventLocation = pickedLocation;
      });
    }
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_eventLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a location')),
        );
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a date')),
        );
        return;
      }
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        location: 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
        seatsAvailable: int.parse(_capacityController.text),
        date: _selectedDate,
        latitude: _eventLocation!.latitude,
        longitude: _eventLocation!.longitude,
        visibility: widget.event.visibility,
        // Use the selected display string
        categories: _selectedCategory!,
        groupID: widget.event.groupID,
      );

      // Call the callback to handle the updated event
      widget.onEventUpdated(updatedEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );

      Navigator.pop(context); // Go back to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
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
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the event title' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),

              // Seats Available
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Seats Available'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter the capacity';
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Event Category'),
                // Value must match one of the items in _categories (or be null)
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Location
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLocation,
                    child: const Text('Pick Location'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _eventLocation == null
                          ? 'No location selected'
                          : 'Lat: ${_eventLocation!.latitude}, Lng: ${_eventLocation!.longitude}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate == null
                        ? 'No date chosen'
                        : DateFormat.yMd().format(_selectedDate!),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Update Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateEvent,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
