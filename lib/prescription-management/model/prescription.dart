class Prescription {
  final int prescriptionId;
  final int patientId;
  final int professionalId;
  final DateTime startDate;
  final DateTime endDate;
  final List<Pill> pills;

  Prescription({
    required this.prescriptionId,
    required this.patientId,
    required this.professionalId,
    required this.startDate,
    required this.endDate,
    required this.pills,
  });

  Prescription.basic({
    required this.patientId,
    required this.professionalId,
    required this.startDate,
    required this.endDate,
  }):
    prescriptionId = 0,
    pills = [];

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescriptionId: json['prescriptionId'],
      patientId: json['patientId'],
      professionalId: json['professionalId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      pills: (json['pills'] as List).map((i) => Pill.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'patientId': patientId,
      'professionalId': professionalId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'pills': pills.map((i) => i.toJson()).toList(),
    };
  }
}

class Pill {
  final String name;
  final String description;
  final int quantity;
  final String frequency;

  Pill({
    required this.name,
    required this.description,
    required this.quantity,
    required this.frequency,
  });

  factory Pill.fromJson(Map<String, dynamic> json) {
    return Pill(
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      frequency: json['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'frequency': frequency,
    };
  }
}