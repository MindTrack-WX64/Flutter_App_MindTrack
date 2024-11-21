class ClinicalHistory {
  final int clinicalId;
  final int patientId;
  final String background;
  final String consultationReason;
  final String consultationDate;

  ClinicalHistory({
    required this.clinicalId,
    required this.patientId,
    required this.background,
    required this.consultationReason,
    required this.consultationDate,
  });

  ClinicalHistory.basic({
    required this.patientId,
    required this.background,
    required this.consultationReason,
    required this.consultationDate,
  }) : clinicalId = 0;

  factory ClinicalHistory.fromJson(Map<String, dynamic> json) {
    return ClinicalHistory.basic(
      patientId: json['patientId'],
      background: json['background'],
      consultationReason: json['consultationReason'],
      consultationDate: json['consultationDate'],
    );
  }

  factory ClinicalHistory.fromJsonBasic(Map<String, dynamic> json) {
    return ClinicalHistory(
      clinicalId: json['clinicalHistoryId'],
      patientId: json['patientId'],
      background: json['background'],
      consultationReason: json['consultationReason'],
      consultationDate: json['consultationDate'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'clinicalId': clinicalId,
      'patientId': patientId,
      'background': background,
      'consultationReason': consultationReason,
      'consultationDate': consultationDate,
    };
  }
}