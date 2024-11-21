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
    print(response.body);
    print("patientId: $patientId");

    if (response.statusCode == 200) {
      final List<dynamic> clinicalHistoryList = json.decode(response.body);
      if (clinicalHistoryList.isNotEmpty) {
        final Map<String, dynamic> clinicalHistory = clinicalHistoryList[0];
        return ClinicalHistory.fromJsonBasic(clinicalHistory);
      } else {
        throw Exception('Clinical history list is empty');
      }
    } else {
      throw Exception('Failed to load clinical history');
    }
  }
  Future<ClinicalHistory> updateById(int clinicalId, String token, String background, String consultationReason) async {
    final body = json.encode({
      'background': background,
      'consultationReason': consultationReason,
    });

    final response = await http.put(
      Uri.parse('$apiUrl$resourceEndpoint/$clinicalId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return ClinicalHistory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update clinical history');
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