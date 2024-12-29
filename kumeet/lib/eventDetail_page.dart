import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'event.dart' as app_event;
import 'event_service.dart';
import "login_page.dart";

class EventDetailPage extends StatefulWidget {
  final app_event.Event event;
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
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  /// Replace with how you fetch username from your app’s global/auth state.
  final String? userName = GlobalState().userName; 
  
  final EventService _eventService = EventService();
  
  String? formattedAddress;
  bool _isJoined = false;    // Tracks if the user has joined the event
  bool _isLoadingJoin = false;  // Tracks if a join request is in progress

  @override
  void initState() {
    super.initState();
    _fetchAddress();
    _checkIfAlreadyJoined();
  }

  /// Checks if the current user has already joined this event
  Future<void> _checkIfAlreadyJoined() async {
    if (userName == null || widget.event.id == null) {
      return;
    }
    try {
      final joinedEvents = await _eventService.getEventsByUser(userName!);
      print(joinedEvents);
      if (joinedEvents.any((e) => e.id == widget.event.id)) {
        setState(() {
          _isJoined = true;
        });
      }
    } catch (e) {
      print('Error checking joined events: $e');
    }
  }

  /// Joins the event if not already joined
  Future<void> _joinEvent() async {
    if (userName == null || widget.event.id == null) return;
    setState(() {
      _isLoadingJoin = true;
    });
    final success = await _eventService.joinEvent(userName!, widget.event.id!);
    setState(() {
      _isLoadingJoin = false;
    });
    if (success) {
      setState(() {
        _isJoined = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully joined ${widget.event.title}!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to join event.')),
      );
    }
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
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }

  Future<void> _addEventToDeviceCalendar() async {
    // Request permissions for calendar access
    final permissionResult = await _deviceCalendarPlugin.requestPermissions();
    if (!permissionResult.isSuccess || permissionResult.data != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calendar permission not granted'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Retrieve available calendars
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (!calendarsResult.isSuccess || calendarsResult.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No calendars available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final selectedCalendar = calendarsResult.data!.first;
    final startDate = widget.event.date ?? DateTime.now();
    final endDate = startDate.add(const Duration(hours: 2)); 
    final tzStart = tz.TZDateTime.from(startDate, tz.local);
    final tzEnd = tz.TZDateTime.from(endDate, tz.local);

    // Create a calendar event
    final calendarEvent = Event(
      selectedCalendar.id!,
      title: widget.event.title,
      description: widget.event.description,
      location: formattedAddress ?? widget.event.location,
      start: tzStart,
      end: tzEnd,
    );

    // Add the event to the calendar
    final createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(calendarEvent);
    if (createEventResult!.isSuccess && createEventResult.data != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Event Added'),
            content: const Text('The event has been successfully added to your calendar!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add event to calendar'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps?q=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open the map.';
    }
  }

  void _shareEvent() {
    Share.share(
      'Check out this event: ${widget.event.title}\nLocation: ${formattedAddress ?? widget.event.location}',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide the text for the bottom button
    final buttonText = _isJoined ? 'Already Joined' : 'Join';
    // If user is already joined, disable the button
    final isButtonEnabled = !_isJoined && !_isLoadingJoin;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareEvent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.event.imagePath ?? 'assets/placeholder.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Event Title
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Calendar Section
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.grey),
              title: Text(
                DateFormat('EEEE, MMMM d, yyyy').format(widget.event.date ?? DateTime.now()),
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _addEventToDeviceCalendar,
            ),
            // Location Section
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.grey),
              title: Text(
                formattedAddress ?? 'Fetching address...',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _openMap(widget.event.latitude, widget.event.longitude),
            ),
            const SizedBox(height: 16),
            // Group Info Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'images/group_image.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Group Name', // Replace with actual group name if available
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Capacity: 50', // Replace with group capacity if available
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color.fromARGB(255, 214, 214, 214), thickness: 4),
            // About Section
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(color: Color.fromARGB(255, 214, 214, 214), thickness: 4),
            // Attendees
            Text(
              'Occupancy: ${widget.event.seatsAvailable}/50', // Adjust as needed
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Color.fromARGB(255, 214, 214, 214), thickness: 4),
            // Location Map Preview
            const Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.event.latitude, widget.event.longitude),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('event_location'),
                          position: LatLng(widget.event.latitude, widget.event.longitude),
                        ),
                      },
                      zoomGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => _openMap(widget.event.latitude, widget.event.longitude),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Sticky Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _joinEvent : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoadingJoin
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  buttonText,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      ),
    );
  }
}
