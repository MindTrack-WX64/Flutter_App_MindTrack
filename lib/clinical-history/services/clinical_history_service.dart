import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mind_track_flutter_app/shared/services/base_service.dart';

import '../model/clinical_history_entity.dart';


class ClinicalHistoryService extends BaseService<ClinicalHistory> {
  ClinicalHistoryService() : super(resourceEndpoint: '/clinicalHistories');


  Future<http.Response> createClinicalHistory(ClinicalHistory clinicalHistory, String token) async {
    final clinicalHistoryJson = json.encode(clinicalHistory.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: clinicalHistoryJson,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create clinical history');
    }
    return response;
  }

  Future<ClinicalHistory> getByPatientId(int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/patient/$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> clinicalHistoryList = json.decode(response.body);
      if (clinicalHistoryList.isNotEmpty) {
        final Map<String, dynamic> clinicalHistory = clinicalHistoryList[0];
        return ClinicalHistory.fromJson(clinicalHistory);
      } else {
        throw Exception('Clinical history list is empty');
      }
    } else {
      throw Exception('Failed to load clinical history');
    }
  }



  @override
  ClinicalHistory fromJson(Map<String,dynamic> json) {
    print("On from json");
    return ClinicalHistory.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ClinicalHistory item) {
    return item.toJson();
  }

}