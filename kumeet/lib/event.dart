import 'dart:convert';

class Event {
  final String? id;
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
    this.id,
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
    print(json);
    return Event(
      id: json['id'],
      imagePath: 'images/event_image.png',
      title: json['eventTitle'],
      description: json['eventDescription'],
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      location:"lat: ${json['latitude']}, long: ${json['longitude']} ",
      seatsAvailable: json['maxCapacity'] ?? 0,
      date: DateTime.parse(json['eventTime']),
      badge: json['badge'], // Optional field
      
    );
  }
  
}
