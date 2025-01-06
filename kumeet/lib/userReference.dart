class UserReference {
  final String userId;
  final DateTime joinAt;
  final String role;
  final String status;

  UserReference({
    required this.userId,
    required this.joinAt,
    required this.role,
    required this.status,
  });
  factory UserReference.fromJson(Map<String, dynamic> json) {
    return UserReference(
      userId: json['userId'],
      joinAt: DateTime.parse(json['joinAt']),
      role: json['role'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'joinAt': joinAt.toIso8601String(),
      'role': role,
      'status': status,
    };
  }
}