class Professional {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;
  final DateTime birthDate;
  final String professionalType;

  Professional({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.professionalType,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      birthDate: DateTime.parse(json['birthDate']),
      professionalType: json['professionalType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
      'professionalType': professionalType,
    };
  }
}