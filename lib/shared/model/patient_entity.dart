class Patient {
  final int patientId;
  final String? username;
  final String? password;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime birthDate;

  Patient({
    required this.patientId, // Add id to the constructor
    this.username = " ",
    this.password = " ",
    required this.fullName,
    required this.email,
    this.phone,
    required this.birthDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['userId'], // Parse id from JSON
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': patientId, // Add id to JSON
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}