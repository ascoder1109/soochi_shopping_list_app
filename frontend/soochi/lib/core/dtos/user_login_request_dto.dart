class UserLoginRequestDTO {
  final String email;
  final String password;

  UserLoginRequestDTO({
    required this.email,
    required this.password,
  });


  factory UserLoginRequestDTO.fromJson(Map<String, dynamic> json) {
    return UserLoginRequestDTO(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
