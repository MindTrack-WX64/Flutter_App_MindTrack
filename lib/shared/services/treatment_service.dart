import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_service.dart';
import '../model/tratment_plan.dart';

class TreatmentService extends BaseService<TreatmentPlan> {
  TreatmentService() : super(resourceEndPoint: '/treatment-plans');

  @override
  Future<List<TreatmentPlan>> getAll() async {
    final response = await http.get(Uri.parse('$apiUrl$resourceEndPoint'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => fromJson(model)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<List<TreatmentPlan>> getByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$resourceEndPoint/patient/$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => fromJson(model)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TreatmentPlan>> getByProfessionalId(int professionalId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint/professional/$professionalId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => fromJson(model)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  TreatmentPlan fromJson(Map<String, dynamic> json) {
    return TreatmentPlan.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(TreatmentPlan item) {
    return item.toJson();
  }
}