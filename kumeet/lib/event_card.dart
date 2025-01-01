import 'dart:convert';     // for base64Decode
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

    // If event.base64Image exists, decode it
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
        // If decoding fails for some reason, fallback
        imageWidget = Image.asset(
          event.imagePath ?? 'images/event_image.png',
          fit: BoxFit.cover,
          width: cardWidth,
          height: 150,
        );
      }
    } else {
      // No photo from server -> fallback to your local asset
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
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: 150,
                    child: imageWidget,
                  ),
                  // The rest is unchanged...
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      // ...
                      child: Text(
                        '${event.seatsAvailable} going',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    // ...
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.share, color: Colors.black),
                      onPressed: () => _shareEvent(context),
                    ),
                  ),
                ],
              ),
              // Event details...
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (event.date != null)
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.date!),
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
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
