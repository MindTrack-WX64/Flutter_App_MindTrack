import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/model/patient_entity.dart';
import '../../shared/services/base_service.dart';

class NewPatientService extends BaseService<Patient> {
  NewPatientService() : super(resourceEndpoint: '/authentication/sign-up/patient');

  Future<http.Response> createPatient(Patient patient, String token) async {
    final patientJson = json.encode(patient.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: patientJson,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create patient');
    }
    return response;
  }

  @override
  Patient fromJson(Map<String, dynamic> json) {
    return Patient.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Patient item) {
    return item.toJson();
  }
}