class Event {
  final String? id;
  final String? imagePath; // still can keep this for fallback/placeholder
  String? base64Image;     // <-- new field to hold the base64 data from server
  String title;
  String description;
  String location;
  int seatsAvailable;
  DateTime? date;
  final String? badge;
  double latitude;
  double longitude;
  bool visibility;
  String categories;
  String? groupID;

  Event({
    this.id,
    this.imagePath,
    this.base64Image,
    required this.title,
    required this.description,
    required this.location,
    required this.seatsAvailable,
    this.date,
    this.badge,
    required this.latitude,
    required this.longitude,
    required this.visibility,
    required this.categories,
    this.groupID
  });

  // The toJson and toJson2 remain unchanged...
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': seatsAvailable,
      'time': date?.toIso8601String(),
      'visibility': visibility,
      'categories': categories,
      'groupID': groupID
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': seatsAvailable,
      'time': date?.toIso8601String(),
      'visibility': visibility,
      'categories': categories,
      'groupID': groupID
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    // 1) Safely parse the date
    DateTime? parsedDate;
    if (json['eventTime'] != null) {
      parsedDate = DateTime.parse(json['eventTime']);
    }

    // 2) Extract the base64 image if it exists
    String? base64Image;
    if (json['photo'] != null &&
        json['photo']['image'] != null &&
        json['photo']['image']['data'] != null) {
      base64Image = json['photo']['image']['data'];
    }

    return Event(
      id: json['id'],
      imagePath: 'images/event_image.png', // fallback asset
      base64Image: base64Image,            // store the base64 for actual image
      title: json['eventTitle'],
      description: json['eventDescription'],
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      location: "lat: ${json['latitude']}, long: ${json['longitude']}",
      seatsAvailable: json['maxCapacity'] ?? 0,
      date: parsedDate,
      badge: json['badge'], // optional
      visibility: json['visibility'],
      categories: json['categories'],
      groupID: json['groupID'],
    );
  }
}
