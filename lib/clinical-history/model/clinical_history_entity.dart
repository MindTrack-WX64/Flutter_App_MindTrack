class ClinicalHistory {
  final int patientId;
  final String background;
  final String consultationReason;
  final String consultationDate;

  ClinicalHistory({
    required this.patientId,
    required this.background,
    required this.consultationReason,
    required this.consultationDate,
  });

  factory ClinicalHistory.fromJson(Map<String, dynamic> json) {
    return ClinicalHistory(
      patientId: json['patientId'],
      background: json['background'],
      consultationReason: json['consultationReason'],
      consultationDate: json['consultationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'background': background,
      'consultationReason': consultationReason,
      'consultationDate': consultationDate,
    };
  }
}