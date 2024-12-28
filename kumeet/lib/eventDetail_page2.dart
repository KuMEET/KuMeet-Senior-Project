import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumeet/edit_eventPage.dart';
import 'package:kumeet/pendingUsersPage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.event.imagePath ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.event.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Location: ${widget.event.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text('${widget.event.seatsAvailable} seats available',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            if (widget.event.date != null)
              Text(
                'Date: ${DateFormat.yMMMMd().format(widget.event.date!)}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _isProcessing ? null : _editEvent,
                  child: _isProcessing
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Edit Event',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _deleteEvent,
                  child: _isProcessing
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Delete Event',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(height: 16),
                if (!widget.event.visibility)
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _navigateToPendingUsers,
                    child: const Text(
                      'Pending Users',
                      style: TextStyle(fontSize: 18),
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
