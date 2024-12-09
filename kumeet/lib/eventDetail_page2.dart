import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/edit_eventPage.dart';
import 'package:kumeet/login_page.dart';
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
  final EventService eventService = EventService(); // EventService instance
  String? userName = GlobalState().userName;

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
          Navigator.of(context).pop(); // Navigate back after deletion
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete the event.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting event: $e'),
            duration: const Duration(seconds: 2),
          ),
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
      
      final success = await eventService.updateEvent(updatedEvent,widget.event.id);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Group "${updatedEvent.title}" updated successfully!',
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update group.')),
            );
          }

      widget.onEventUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.event.imagePath!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Event Title
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Event Description
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  widget.event.location,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seats Available
            Row(
              children: [
                const Icon(Icons.event_seat, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  '${widget.event.seatsAvailable} seats available',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date
            if (widget.event.date != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMMMMd().format(widget.event.date!),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Edit and Delete Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isProcessing ? null : _editEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Edit Event',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _deleteEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Delete Event',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}