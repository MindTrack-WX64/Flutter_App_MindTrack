import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';
import '../model/patient_entity.dart';

class PatientService extends BaseService<Patient> {

  PatientService() : super(resourceEndpoint: '/profiles/patients');


  Future<Patient> getByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("in patient service");

    if (response.statusCode == 200) {
      print("in patient service2");
      final responseBody = response.body;
      final json = jsonDecode(responseBody);
      print("in patient service3");
      print("Patient JSON: $json");
      return Patient.fromJson(json);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<List<Patient>> getPatientsByProfessionalId(int professionalId, String token ) async
  {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/professional/$professionalId'),
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