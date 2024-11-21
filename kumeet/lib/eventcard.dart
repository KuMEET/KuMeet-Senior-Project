// eventcard.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Event Image
            Image.asset(
              event.imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            
            // Seats Left in the upper-left corner
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${event.seatsAvailable} seats left',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

            // Badge (if available) in the bottom-left corner
            if (event.badge != null)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.white,
                  child: Text(
                    event.badge!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            
            // Event Title at the bottom
            Positioned(
              bottom: 40,
              left: 16,
              child: Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Event Date below the title
            if (event.date != null)
              Positioned(
                bottom: 20,
                left: 16,
                child: Text(
                  DateFormat.yMMMd().format(event.date!), // Format the date
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
