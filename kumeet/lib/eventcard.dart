import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event.dart'; // Ensure you have this file with the Event class correctly defined.

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final double cardWidth;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    this.cardWidth = 280, // Default width, can be adjusted or set via constructor
  }) : super(key: key);

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
        child: Container(
          width: cardWidth,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                event.imagePath ?? 'assets/placeholder.jpg', // Default placeholder if imagePath is null
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (event.date != null) // Checking if date is not null before displaying
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.date!),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    // Display seats if available
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${event.seatsAvailable} seats left',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (event.badge != null) // Display badge if available
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          event.badge!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.yellowAccent, // Adjust color as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
