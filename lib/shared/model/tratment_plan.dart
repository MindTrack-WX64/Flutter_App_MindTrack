class TreatmentPlan {
  final int? treatmentPlanId; // New attribute
  final int patientId;
  final int professionalId;
  final DateTime startDate;
  final String? endDate;
  final bool isFinished;
  final String description;
  final List<Session> sessions;
  final List<String> patientStates;
  final List<String> biologicalFunctions;
  final List<String> diagnostics;
  final List<String> tasks;

  TreatmentPlan({
    this.treatmentPlanId,// New attribute
    required this.patientId,
    required this.professionalId,
    required this.startDate,
    this.endDate,
    required this.isFinished,
    required this.description,
    required this.sessions,
    required this.patientStates,
    required this.biologicalFunctions,
    required this.diagnostics,
    required this.tasks,
  });

  // Additional constructor
  TreatmentPlan.basic({
    required this.patientId,
    required this.professionalId,
    required this.description,
  })  :
        startDate = DateTime.now(),
        treatmentPlanId = 0,
        endDate = "undefined",
        isFinished = false,
        sessions = [],
        patientStates = [],
        biologicalFunctions = [],
        diagnostics = [],
        tasks = [];

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      treatmentPlanId: json['treatmentPlanId'], // New attribute
      patientId: json['patientId'],
      professionalId: json['professionalId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'],
      isFinished: json['isFinished'],
      description: json['description'],
      sessions: (json['sessions'] as List).map((i) => Session.fromJson(i)).toList(),
      patientStates: List<String>.from(json['patientStates']),
      biologicalFunctions: List<String>.from(json['biologicalFunctions']),
      diagnostics: List<String>.from(json['diagnostics']),
      tasks: List<String>.from(json['tasks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatmentPlanId': treatmentPlanId, // New attribute
      'patientId': patientId,
      'professionalId': professionalId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate,
      'isFinished': isFinished,
      'description': description,
      'sessions': sessions.map((i) => i.toJson()).toList(),
      'patientStates': patientStates,
      'biologicalFunctions': biologicalFunctions,
      'diagnostics': diagnostics,
      'tasks': tasks,
    };
  }

  // Additional toJson method
  Map<String, dynamic> toBasicJson() {
    return {
      'treatmentPlanId': treatmentPlanId, // New attribute
      'patientId': patientId,
      'professionalId': professionalId,
      'description': description,
    };
  }
}

class Session {
  final int id;
  final int patientId;
  final int professionalId;
  final String sessionDate;

  Session({
    required this.id,
    required this.patientId,
    required this.professionalId,
    required this.sessionDate,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      patientId: json['patientId'],
      professionalId: json['professionalId'],
      sessionDate: json['sessionDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'professionalId': professionalId,
      'sessionDate': sessionDate,
    };
  }
}