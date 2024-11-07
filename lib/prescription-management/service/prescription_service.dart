import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/prescription.dart';
import '../../shared/services/base_service.dart';

class PrescriptionService extends BaseService<Prescription> {
  PrescriptionService() : super(resourceEndPoint: '/prescriptions');

  Future<http.Response> createPrescription(Prescription prescription, String token) async {
    return await create(prescription, token);
  }

  Future<http.Response> addPill(int prescriptionId, Pill pill, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint/$prescriptionId/pills'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(pill.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add pill');
    }
    return response;
  }

  Future<List<Prescription>> findByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => fromJson(model)).toList();
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