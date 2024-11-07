import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mind_track_flutter_app/shared/services/base_service.dart';
import '../model/clinical_history_entity.dart';


class ClinicalHistoryService extends BaseService<ClinicalHistory> {
  ClinicalHistoryService() : super(resourceEndPoint: '/clinicalHistories');


  Future<http.Response> createClinicalHistory(ClinicalHistory clinicalHistory, String token) async {
    final clinicalHistoryJson = json.encode(clinicalHistory.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
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

  @override
  ClinicalHistory fromJson(Map<String, dynamic> json) {
    return ClinicalHistory.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ClinicalHistory item) {
    return item.toJson();
  }

}