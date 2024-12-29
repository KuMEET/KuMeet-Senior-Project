class Group {
  final String? id;
  final String? imagePath;
  String name;
  int capacity;
  final int? memberCount;
  bool visibility;
  String categories;

  Group({
    this.id,
    this.imagePath,
    required this.name,
    //required this.description,
    required this.capacity,
    this.memberCount,
    required this.visibility,
    required this.categories

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      //'description': description,
      'capacity': capacity,
      'visibility':visibility,
      'categories':categories
    };
  }
    Map<String, dynamic> toJson2() {
    return {
      'id':id,
      'groupName': name,
      //'description': description,
      'capacity': capacity,
      'memberCount': memberCount,
      'visibility': visibility,
      'categories':categories
    };
  }
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      imagePath: 'images/group_image1.png',
      name: json['groupName'],
      //description: json['eventDescription'],
      capacity: json['capacity'] ?? 0,
      memberCount: json['memberCount'] ?? 0,
      visibility: json['visibility'],
      categories: json['categories']
    );
  }
  
}