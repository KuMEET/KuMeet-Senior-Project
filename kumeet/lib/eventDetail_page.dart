import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:kumeet/login_page.dart';
import 'event.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;
  final VoidCallback onAddToCalendar;
  final bool isAdded; // Boolean to check if the event is already added

  const EventDetailPage({
    super.key,
    required this.event,
    required this.onAddToCalendar,    
    required this.isAdded,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isAdding = false;
  String? UserName = GlobalState().userName;

  Future<void> _joinEvent() async {
    setState(() {
      _isAdding = true;
    });

    final url = Uri.parse(
        'http://localhost:8080/add-to-event/${UserName}/${widget.event.id}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.onAddToCalendar();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${widget.event.title}!'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isAdding = false;
      });
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
                  image: AssetImage(widget.event.imagePath),
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

            // Join Event Button
            ElevatedButton(
              onPressed: widget.isAdded || _isAdding
                  ? null
                  : () {
                      _joinEvent();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isAdded ? Colors.grey : Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isAdding
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      widget.isAdded ? 'Already Joined' : 'Join Event',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
