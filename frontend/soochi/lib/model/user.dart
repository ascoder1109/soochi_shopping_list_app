class User {
  final String name;
  final String email;

  User({
    // Require id in the constructor
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
