import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final Row? trailing;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap, this.trailing,
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
        elevation: 5, 
        color: Colors.grey[850], 
        child: Stack(
          children: [
            // Event Image
            Image.asset(
              event.imagePath!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken, 
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                  decoration: BoxDecoration(
                    color: Colors.deepOrange, 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.badge!,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                  style: const TextStyle(
                    color: Colors.white70, 
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}