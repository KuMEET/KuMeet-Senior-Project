class Event {
  final String imagePath;
  final String title;
  final String description;
  final String location;
  final int seatsAvailable;
  final DateTime? date;
  final String? badge;
  final double latitude;  // Latitude for event location
  final double longitude; // Longitude for event location

  Event({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.location,
    required this.seatsAvailable,
    this.date,
    this.badge,
    required this.latitude,
    required this.longitude,
  });

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': seatsAvailable,
      'time': date?.toIso8601String(),
    };
  }
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      imagePath: 'images/event_image.png', // Default image for now
      title: json['title'],
      description: json['description'],
      location: json['location'] ?? '', // Default to empty string if null
      seatsAvailable: json['capacity'] ?? 0,
      date: json['time'] != null ? DateTime.parse(json['time']) : null,
      badge: json['badge'], // Optional field
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }
}
