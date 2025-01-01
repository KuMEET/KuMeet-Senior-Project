import 'dart:convert'; // for base64Decode
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
    this.cardWidth = 350,
  }) : super(key: key);

  void _shareEvent(BuildContext context) {
    Share.share(
      'Check out this event: ${event.title}\n\nDescription: ${event.description}\nLocation: ${event.location}',
      subject: 'Event: ${event.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Decode base64Image or fallback to local asset
    if (event.base64Image != null) {
      try {
        final decodedBytes = base64Decode(event.base64Image!);
        imageWidget = Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          width: cardWidth,
          height: 150,
        );
      } catch (e) {
        imageWidget = Image.asset(
          event.imagePath ?? 'images/event_image.png',
          fit: BoxFit.cover,
          width: cardWidth,
          height: 150,
        );
      }
    } else {
      imageWidget = Image.asset(
        event.imagePath ?? 'images/event_image.png',
        fit: BoxFit.cover,
        width: cardWidth,
        height: 150,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top image with seats available and share button
              Stack(
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: 150,
                    child: imageWidget,
                  ),
                  // Seats available container
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
                        '${event.seatsAvailable} seats available',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Share button container
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
                          color: Colors.black,
                        ),
                        onPressed: () => _shareEvent(context),
                      ),
                    ),
                  ),
                ],
              ),
              // Event details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 8),
                    // Event description
                    SizedBox(
  width: cardWidth-20, // Specify the desired width
  child: Text(
    event.description,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(fontSize: 14),
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
