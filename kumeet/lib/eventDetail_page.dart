import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event.dart';

class EventDetailPage extends StatelessWidget {
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
                  image: AssetImage(event.imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), // Dark overlay for readability
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Event Title
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White for dark theme
              ),
            ),
            const SizedBox(height: 8),

            // Event Description
            Text(
              event.description,
              style: const TextStyle(fontSize: 16, color: Colors.white70), // Subtle white
            ),
            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.deepOrange), // Orange accent
                const SizedBox(width: 8),
                Text(
                  event.location,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seats Available
            Row(
              children: [
                const Icon(Icons.event_seat, color: Colors.white70), // Subtle white
                const SizedBox(width: 8),
                Text(
                  '${event.seatsAvailable} seats available',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date
            if (event.date != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70), // Subtle white
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMMMMd().format(event.date!),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Add to Calendar Button
            ElevatedButton(
              onPressed: isAdded
                  ? null
                  : () {
                      onAddToCalendar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${event.title} added to your calendar!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).popUntil;
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isAdded ? Colors.grey : Colors.deepOrange, // Grey if disabled
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded button
                ),
              ),
              child: Text(
                isAdded ? 'Already in Calendar' : 'Add to Calendar',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
