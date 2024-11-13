import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/patient_entity.dart';
import 'base_service.dart';

class PatientService extends BaseService<Patient> {

  PatientService() : super(resourceEndpoint: '/profiles/patients');

  Future<Patient> getByPatientId(int userId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final json = jsonDecode(responseBody);
      return Patient.fromJson(json);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<String> getPatientNameById(int userId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['fullName']);
      return data['fullName'];
    } else {
      throw Exception('Failed to load patient name');
    }
  }

  Future<List<Patient>> getPatientsByProfessionalId(int professionalId, String token ) async
  {
    final response = await http.get(
      Uri.parse('$apiUrl/profiles/professionals/$professionalId/patients'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      Iterable list = json.decode(responseBody);
      List<Patient> patients = list.map((model) {
        return fromJson(model);
      }).toList();
      return patients;
    } else {
      throw Exception('Failed to load data');
    }
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