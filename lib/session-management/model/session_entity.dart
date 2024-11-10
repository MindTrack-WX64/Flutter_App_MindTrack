class SessionEntity {
  final int? id;
  final int patientId;
  final int professionalId;
  final DateTime sessionDate;
  final int? treatmentPlanId;

  SessionEntity({
    this.id,
    required this.patientId,
    required this.professionalId,
    required this.sessionDate,
    this.treatmentPlanId,
  });

  factory SessionEntity.fromJson(Map<String, dynamic> json) {
    return SessionEntity(
      id: json['id'],
      patientId: json['patientId'],
      professionalId: json['professionalId'],
      sessionDate: json['sessionDate'],
      treatmentPlanId: json['treatmentPlanId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'professionalId': professionalId,
      'sessionDate': sessionDate,
      'treatmentPlanId': treatmentPlanId,
    };
  }
}