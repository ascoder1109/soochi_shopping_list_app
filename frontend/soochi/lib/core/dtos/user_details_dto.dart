class UserDetailsDTO {
  final String username;
  final String email;

  UserDetailsDTO({
    required this.username,
    required this.email,
  });

  factory UserDetailsDTO.fromJson(Map<String, dynamic> json) {
    return UserDetailsDTO(
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
