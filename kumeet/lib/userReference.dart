import 'dart:convert';

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

  // Factory method to create a UserReference object from JSON
  factory UserReference.fromJson(Map<String, dynamic> json) {
    return UserReference(
      userId: json['userId'],
      joinAt: DateTime.parse(json['joinAt']),
      role: json['role'],
      status: json['status'],
    );
  }

  // Convert a UserReference object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'joinAt': joinAt.toIso8601String(),
      'role': role,
      'status': status,
    };
  }
}

// Example usage
void main() {
  // Example JSON data
  const jsonString = '''
    {
      "userId": "123e4567-e89b-12d3-a456-426614174000",
      "joinAt": "2024-01-01T12:00:00Z",
      "role": "Member",
      "status": "Pending"
    }
  ''';

  // Parsing JSON string to UserReference object
  final jsonData = jsonDecode(jsonString);
  final userReference = UserReference.fromJson(jsonData);

  print('User ID: ${userReference.userId}');
  print('Join At: ${userReference.joinAt}');
  print('Role: ${userReference.role}');
  print('Status: ${userReference.status}');

  // Converting UserReference object back to JSON
  final jsonOutput = userReference.toJson();
  print('JSON Output: ${jsonEncode(jsonOutput)}');
}
