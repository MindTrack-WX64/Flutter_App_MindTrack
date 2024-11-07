import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_service.dart';
import '../model/tratment_plan.dart';

class TreatmentService extends BaseService<TreatmentPlan> {
  TreatmentService() : super(resourceEndPoint: '/treatment-plans');

  Future<http.Response> createTreatmentPlan(TreatmentPlan treatmentPlan, String token) async {
    final treatmentPlanJson = json.encode(treatmentPlan.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: treatmentPlanJson,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create treatment plan');
    }
    return response;
  }
  Future<TreatmentPlan> getByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$resourceEndPoint/patient/$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final treatmentPlan = json.decode(response.body);
      return fromJson(treatmentPlan);
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
    print("in treatment service");
    if (response.statusCode == 200) {
      print("in treatment service 2");
      final responseBody = response.body;
      Iterable list = json.decode(responseBody);
      List<TreatmentPlan> treatmentPlans = list.map((model) {
        return fromJson(model);
      }).toList();
      print("in treatment service 3");
      return treatmentPlans;
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