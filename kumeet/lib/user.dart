class User {
  String userName;
  String name;
  String surname;
  String password;
  String email;

  User({required this.userName, required this.name, required this.surname, required this.password, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      name: json['name'],
      surname: json['surname'],
      password: json['password'], // Note: Handling passwords like this can be insecure
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'name': name,
      'surname': surname,
      'password': password,
      'email': email,
    };
  }
}
