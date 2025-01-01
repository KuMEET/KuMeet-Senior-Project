import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event.dart';
import 'dart:convert';

class MapEventCard extends StatelessWidget {
  final Event event;
  final String distanceKm;
  final VoidCallback onTap;

  const MapEventCard({
    Key? key,
    required this.event,
    required this.distanceKm,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Decide which image to show
    Widget imageWidget;
    if (event.base64Image != null) {
      try {
        final decodedBytes = base64Decode(event.base64Image!);
        imageWidget = Image.memory(
          decodedBytes,
          width: 120,
          height: 80,
          fit: BoxFit.cover,
        );
      } catch (e) {
        imageWidget = Image.asset(
          event.imagePath ?? 'images/event_image.png',
          width: 120,
          height: 80,
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        event.imagePath ?? 'images/event_image.png',
        width: 120,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Image and Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image (wide, short rectangle)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      event.imagePath!,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Event Details (aligned vertically)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Date
                        if (event.date != null)
                          Text(
                            DateFormat('MMM dd, yyyy').format(event.date!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 4),
                        // Event Title
                        Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Event Description
                        Text(
                          event.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom Row: Distance and Attendees
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Distance (left-aligned)
                  Text(
                    '$distanceKm km away',
                    style: theme.textTheme.bodySmall,
                  ),
                  // Attendees (right-aligned)
                  Text(
                    '${event.seatsAvailable} going',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
