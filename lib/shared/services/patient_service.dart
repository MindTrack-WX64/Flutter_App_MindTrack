import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';
import '../model/patient_entity.dart';

class PatientService extends BaseService<Patient> {
  PatientService() : super(resourceEndPoint: '/profiles/patients');


  Future<Patient> getByPatientId(int patientId, String token) async {
    print('$apiUrl$resourceEndPoint/$patientId');
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint/$patientId'),
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

  @override
  Patient fromJson(Map<String, dynamic> json) {
    return Patient.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Patient item) {
    return item.toJson();
  }
}