import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final double cardWidth;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    this.cardWidth = 350, // Default width
  }) : super(key: key);

  // Share functionality using share_plus
  void _shareEvent(BuildContext context) {
    Share.share(
      'Check out this event: ${event.title}\n\nDescription: ${event.description}\nLocation: ${event.location}',
      subject: 'Event: ${event.title}',
    );
  }

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
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image with attendee number and share button
              Stack(
                children: [
                  // Cropped image with fixed dimensions
                  Container(
                    width: cardWidth,
                    height: 150,
                    child: Image.asset(
                      event.imagePath ?? 'assets/placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Overlay for attendee number
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${event.seatsAvailable} going',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Share button in a white rounded box with shadow
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(
                          Icons.share,
                          color: Colors.black, // Black icon color
                        ),
                        onPressed: () => _shareEvent(context), // Share event logic
                      ),
                    ),
                  ),
                ],
              ),
              // Event details below the image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event title
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Event date
                    if (event.date != null)
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.date!),
                        style: const TextStyle(
                          fontSize: 12, 
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Event description
                    Text(
                      event.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
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
