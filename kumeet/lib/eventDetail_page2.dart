import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/edit_eventPage.dart';
import 'package:kumeet/pendingUsersPage.dart';
import 'package:kumeet/eventMembers_page.dart'; // Ensure this page is created
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event.dart';
import 'event_service.dart';

class EventDetailPage2 extends StatefulWidget {
  final Event event;
  final VoidCallback onEventUpdated;
  final VoidCallback onEventDeleted;

  const EventDetailPage2({
    super.key,
    required this.event,
    required this.onEventUpdated,
    required this.onEventDeleted,
  });

  @override
  _EventDetailPage2State createState() => _EventDetailPage2State();
}

class _EventDetailPage2State extends State<EventDetailPage2> {
  bool _isProcessing = false;
  final EventService eventService = EventService();
  String? formattedAddress; // Holds the formatted address of the location

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    const String mapApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
    final String host = 'https://maps.googleapis.com/maps/api/geocode/json';
    final String url =
        '$host?key=$mapApiKey&language=en&latlng=${widget.event.latitude},${widget.event.longitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map data = jsonDecode(response.body);
        setState(() {
          formattedAddress = data["results"][0]["formatted_address"];
        });
      } else {
        setState(() {
          formattedAddress = 'Unknown location';
        });
      }
    } catch (e) {
      setState(() {
        formattedAddress = 'Error fetching location';
      });
      print('Error fetching address: $e');
    }
  }

  Future<void> _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isProcessing = true;
      });

      try {
        final success = await eventService.deleteEvent(widget.event);
        if (success) {
          widget.onEventDeleted();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event "${widget.event.title}" deleted successfully.'),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete the event.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting event: $e')),
        );
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _editEvent() async {
    final updatedEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(
          event: widget.event,
          onEventUpdated: (updatedEvent) {
            Navigator.pop(context, updatedEvent);
          },
        ),
      ),
    );

    if (updatedEvent != null) {
      setState(() {
        widget.event.title = updatedEvent.title;
        widget.event.description = updatedEvent.description;
        widget.event.location = updatedEvent.location;
        widget.event.seatsAvailable = updatedEvent.seatsAvailable;
        widget.event.date = updatedEvent.date;
        widget.event.latitude = updatedEvent.latitude;
        widget.event.longitude = updatedEvent.longitude;
      });

      final success = await eventService.updateEvent(updatedEvent, widget.event.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event "${updatedEvent.title}" updated successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update event.')),
        );
      }

      widget.onEventUpdated();
    }
  }

  void _navigateToPendingUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingUsersPage(eventId: widget.event.id!),
      ),
    );
  }

  void _navigateToEventMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventMembersPage(eventId: widget.event.id!, eventName: widget.event.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.event.imagePath ?? 'assets/placeholder.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Location: ${formattedAddress ?? 'Fetching address...'}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Seats Available: ${widget.event.seatsAvailable}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (widget.event.date != null)
                      const SizedBox(height: 16),
                      Text(
                        'Date: ${DateFormat.yMMMMd().format(widget.event.date!)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _isProcessing ? null : _navigateToEventMembers,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Event Members'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _editEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Edit Event'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _deleteEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Delete Event'),
                ),
                const SizedBox(height: 16),
                if (!widget.event.visibility)
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _navigateToPendingUsers,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Pending Users'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
