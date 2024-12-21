

class Event {
  final String? id;
  final String? imagePath;
  String title;
  String description;
  String location;
  int seatsAvailable;
  DateTime? date;
  final String? badge;
  double latitude;  // Latitude for event location
  double longitude;
  bool visibility; // Longitude for event location

  Event({
    this.id,
    this.imagePath,
    required this.title,
    required this.description,
    required this.location,
    required this.seatsAvailable,
    this.date,
    this.badge,
    required this.latitude,
    required this.longitude,
    required this.visibility
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
      'visibility': visibility
    };
  }
    // Convert Event to JSON
  Map<String, dynamic> toJson2() {
    return {
      'id': id,
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
      visibility: json['visibility']
    );
  }
  
}
