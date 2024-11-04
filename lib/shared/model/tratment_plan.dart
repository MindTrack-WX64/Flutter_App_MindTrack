class TreatmentPlan {
  final int id;
  final int patientId;
  final int professionalId;
  final List<int> sessions;
  final int clinicalHistoryId;
  final int prescriptionId;
  final int diagnosticId;
  final DateTime startDate;

  TreatmentPlan({
    required this.id,
    required this.patientId,
    required this.professionalId,
    required this.sessions,
    required this.clinicalHistoryId,
    required this.prescriptionId,
    required this.diagnosticId,
    required this.startDate,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      id: json['id'],
      patientId: json['patientId'],
      professionalId: json['professionalId'],
      sessions: List<int>.from(json['sessions']),
      clinicalHistoryId: json['clinicalHistoryId'],
      prescriptionId: json['prescriptionId'],
      diagnosticId: json['diagnosticId'],
      startDate: DateTime.parse(json['startDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'professionalId': professionalId,
      'sessions': sessions,
      'clinicalHistoryId': clinicalHistoryId,
      'prescriptionId': prescriptionId,
      'diagnosticId': diagnosticId,
      'startDate': startDate.toIso8601String(),
    };
  }
}