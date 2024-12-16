class UserLoginResponseDTO {
  final String token;

  UserLoginResponseDTO({
    required this.token,
  });


  factory UserLoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseDTO(
      token: json['token'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
