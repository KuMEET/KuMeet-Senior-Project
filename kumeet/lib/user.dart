
class User {
  String _id;
  String userName;
  String name;
  String surname;
  String password;
  String email;
  List<GroupReference> groupReferenceList;
  List<EventReference> eventReferenceList;
  String? role;

  User({
    required String id,
    required this.userName,
    required this.name,
    required this.surname,
    required this.password,
    required this.email,
    required this.groupReferenceList,
    required this.eventReferenceList,
    this.role
  }): _id = id; // Initialize _id

  // Getter for id
  String get id => _id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      surname: json['surname'],
      password: json['passWord'], // Ensure this is correct as your JSON has "passWord"
      email: json['email'],
      groupReferenceList: List<GroupReference>.from(json['groupReferenceList'].map((x) => GroupReference.fromJson(x))),
      eventReferenceList: List<EventReference>.from(json['eventReferenceList'].map((x) => EventReference.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'surname': surname,
      'passWord': password,
      'email': email,
      'groupReferenceList': List<dynamic>.from(groupReferenceList.map((x) => x.toJson())),
      'eventReferenceList': List<dynamic>.from(eventReferenceList.map((x) => x.toJson())),
    };
  }
  Map<String, dynamic> toJson2() {
    return {
      'userName': userName,
      'name': name,
      'surname': surname,
      'EMail': email,
      'passWord': password,
    };
  }

}

class GroupReference {
  String groupId;
  DateTime joinAt;
  String role;
  String status;

  GroupReference({required this.groupId, required this.joinAt, required this.role, required this.status});

  factory GroupReference.fromJson(Map<String, dynamic> json) {
    return GroupReference(
      groupId: json['groupId'],
      joinAt: DateTime.parse(json['joinAt']),
      role: json['role'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'joinAt': joinAt.toIso8601String(),
      'role': role,
      'status': status,
    };
  }
}

class EventReference {
  String eventId;
  DateTime joinAt;
  String role;
  String status;

  EventReference({required this.eventId, required this.joinAt, required this.role, required this.status});

  factory EventReference.fromJson(Map<String, dynamic> json) {
    return EventReference(
      eventId: json['eventId'],
      joinAt: DateTime.parse(json['joinAt']),
      role: json['role'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'joinAt': joinAt.toIso8601String(),
      'role': role,
      'status': status,
    };
  }
}
