import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _capacityController = TextEditingController(
      text: widget.event.seatsAvailable.toString(),
    );
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

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedEvent = Event(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text,
        location: 'Lat: ${_eventLocation!.latitude}, Long: ${_eventLocation!.longitude}',
        seatsAvailable: int.parse(_capacityController.text),
        date: _selectedDate,
        latitude: _eventLocation!.latitude,
        longitude: _eventLocation!.longitude,
        visibility: widget.event.visibility,
        categories: widget.event.categories,
        groupID: widget.event.groupID
      );

      widget.onEventUpdated(updatedEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );

      Navigator.pop(context); // Go back to the previous page
    }
  }

  Future<void> _pickLocation() async {
    // Normally you’d present a map picker here:
    // final LatLng? pickedLocation = await Navigator.push(...);
    // if (pickedLocation != null) { setState(() => _eventLocation = pickedLocation); }
    // For now, we’re just hardcoding a location:
    setState(() {
      _eventLocation = const LatLng(40.9810, 29.0870);
    });
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
              // Title
              const Text(
                'Edit Event Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Event Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  filled: true, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Capacity Field
              TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pick Location Button & Display
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
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Row
              Row(
                children: [
                  const Icon(Icons.calendar_today),
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
              const SizedBox(height: 24),

              // Update Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateEvent,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Update Group',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
