class Group {
  final String? id;
  final String? imagePath;
  String name;
  //final String description;
  int capacity;
  final int? memberCount;
  bool visibility;

  Group({
    this.id,
    this.imagePath,
    required this.name,
    //required this.description,
    required this.capacity,
    this.memberCount,
    required this.visibility

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      //'description': description,
      'capacity': capacity,
      'visibility':visibility,
    };
  }
    Map<String, dynamic> toJson2() {
    return {
      'id':id,
      'groupName': name,
      'memberCount': memberCount,
      //'description': description,
      'capacity': capacity,
      'visibility': visibility
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
      visibility: json['visibility']
    );
  }
  
}