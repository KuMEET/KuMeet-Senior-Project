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
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'seatsAvailable': seatsAvailable,
      'date': date!.toIso8601String(),
    };
  }
}
