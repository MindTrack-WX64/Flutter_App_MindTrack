import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/prescription.dart';
import '../../shared/services/base_service.dart';

class PrescriptionService extends BaseService<Prescription> {
  PrescriptionService() : super(resourceEndPoint: '/prescriptions');



  Future<http.Response> addPill(int prescriptionId, Map<String, dynamic> pillData, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint/$prescriptionId/pills'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(pillData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add pill');
    }
    return response;
  }

  Future<http.Response> createPrescription(Map<String, dynamic> prescriptionData, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(prescriptionData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create prescription');
    }
    return response;
  }


  Future<Map<String, dynamic>> findByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final prescription = json.decode(response.body);
      if (prescription.isNotEmpty) {
        print(prescription);
        return prescription[0];
      } else {
        throw Exception('No prescriptions found for patient');
      }
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }
  Future<int> getPrescriptionIdByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> prescriptions = json.decode(response.body);
      if (prescriptions.isNotEmpty) {
        return prescriptions.first['id'];
      } else {
        throw Exception('No prescriptions found for patient');
      }
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }


  @override
  Prescription fromJson(Map<String, dynamic> json) {
    return Prescription.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Prescription item) {
    return item.toJson();
  }
}