class UserRegistrationDTO {
  final String userName;
  final String email;
  final String password;

  UserRegistrationDTO({
    required this.userName,
    required this.email,
    required this.password,
  });


  factory UserRegistrationDTO.fromJson(Map<String, dynamic> json) {
    return UserRegistrationDTO(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
    };
  }
}
