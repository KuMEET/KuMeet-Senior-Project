import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

import 'event.dart' as my_app;
import 'package:kumeet/login_page.dart';

class EventDetailPage extends StatefulWidget {
  final my_app.Event event;
  final VoidCallback onAddToCalendar;
  final bool isAdded;

  const EventDetailPage({
    Key? key,
    required this.event,
    required this.onAddToCalendar,
    required this.isAdded,
  }) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isAdding = false;
  String? userName = GlobalState().userName;
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> _joinEvent() async {
    setState(() {
      _isAdding = true;
    });

    final url = Uri.parse('http://localhost:8080/add-to-event/$userName/${widget.event.id}');
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'});

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

  Future<bool> _requestPermissions() async {
    final permissionResult = await _deviceCalendarPlugin.requestPermissions();
    if (permissionResult.isSuccess && permissionResult.data == true) {
      return true;
    }
    return false;
  }

  Future<List<Calendar>> _retrieveCalendars() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult.isSuccess && calendarsResult.data != null) {
      return calendarsResult.data!;
    }
    return [];
  }

  Future<void> _addEventToDeviceCalendar(my_app.Event eventDetails) async {
    final granted = await _requestPermissions();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calendar permission not granted')),
      );
      return;
    }

    final calendars = await _retrieveCalendars();
    if (calendars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No calendars available')),
      );
      return;
    }

    final selectedCalendar = calendars.first;
    final startDate = eventDetails.date ?? DateTime.now();
    final endDate = startDate.add(const Duration(hours: 1));

    final startTime = tz.TZDateTime.from(startDate, tz.local);
    final endTime = tz.TZDateTime.from(endDate, tz.local);

    final calendarEvent = Event(
      selectedCalendar.id!,
      title: eventDetails.title,
      description: eventDetails.description,
      start: startTime,
      end: endTime,
    );

    final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(calendarEvent);
    if (createEventResult!.isSuccess && createEventResult.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added to calendar successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add event to calendar')),
      );
    }
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
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 8),
                Text(
                  widget.event.location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.event_seat),
                const SizedBox(width: 8),
                Text(
                  '${widget.event.seatsAvailable} seats available',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.event.date != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMMMMd().format(widget.event.date!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.isAdded || _isAdding
                  ? null
                  : _joinEvent,
              child: _isAdding
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.isAdded ? 'Already Joined' : 'Join Event',
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
            const SizedBox(height: 16),
            if (widget.isAdded)
              ElevatedButton(
                onPressed: () {
                  _addEventToDeviceCalendar(widget.event);
                },
                child: const Text(
                  'Add to Calendar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
