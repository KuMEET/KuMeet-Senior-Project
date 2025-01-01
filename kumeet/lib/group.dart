class Group {
  final String? id;
  final String? imagePath;
  String? base64Image; // For storing base64-encoded image data from the server
  String name;
  int capacity;
  final int? memberCount;
  bool visibility;
  String categories;

  Group({
    this.id,
    this.imagePath,
    this.base64Image,
    required this.name,
    required this.capacity,
    this.memberCount,
    required this.visibility,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'visibility': visibility,
      'categories': categories,
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'groupName': name,
      'capacity': capacity,
      'memberCount': memberCount,
      'visibility': visibility,
      'categories': categories,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    String? base64Image;
    if (json['photo'] != null &&
        json['photo']['image'] != null &&
        json['photo']['image']['data'] != null) {
      base64Image = json['photo']['image']['data'];
    }

    return Group(
      id: json['id'],
      imagePath: 'images/group_image.png', // Default fallback
      base64Image: base64Image,
      name: json['groupName'],
      capacity: json['capacity'] ?? 0,
      memberCount: json['memberCount'] ?? 0,
      visibility: json['visibility'],
      categories: json['categories'],
    );
  }
}
