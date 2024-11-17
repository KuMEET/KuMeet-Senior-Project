// lib/models/event.dart

class Event {
  final String imagePath;         // Path to event image
  final String title;             // Title of the event
  final String description;       // Detailed description of the event
  final String location;          // Location of the event
  final int seatsAvailable;       // Number of total seats for the event
  final DateTime? date;           // Actual date of the event
  final String? badge;            // Optional: Badge or status indicator (e.g., "Limited Seats")

  Event({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.location,
    required this.seatsAvailable,
    this.date,
    this.badge,
  });
}

