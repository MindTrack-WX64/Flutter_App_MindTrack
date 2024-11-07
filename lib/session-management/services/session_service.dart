import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/services/base_service.dart';

class SessionService extends BaseService {
  SessionService() : super(resourceEndPoint: '/sessions');

  Future<http.Response> createSession(Map<String, dynamic> sessionData, String token) async {
    print('$apiUrl$resourceEndPoint');
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(sessionData),
    );

    print(json.encode(sessionData));
    print(response.statusCode);

    if (response.statusCode != 201) {
      throw Exception('Failed to create session');
    }
    return response;
  }

  Future<Map<String, dynamic>> findByPatientId(int patientId, String token) async {
    print('$apiUrl$resourceEndPoint?patientId=$patientId');
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("on session service");

    print(response.statusCode);
    if (response.statusCode == 201) {
      print("on if");

      if (response.body.isNotEmpty) {
        final session = json.decode(response.body);

        if (session.isNotEmpty) {
          return session;
        } else {
          throw Exception('No sessions found for patient');
        }
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<List<Map<String, dynamic>>> findByProfessionalId(int professionalId, int patientId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint/professional/$professionalId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("On session service");
    if (response.statusCode == 200) {
      print("On if");
      if (response.body.isNotEmpty) {
        final List<dynamic> sessions = json.decode(response.body);
        return sessions
            .where((session) => session['patientId'] == patientId)
            .map((session) => {
          'id': session['id'],
          'patientId': session['patientId'],
          'professionalId': session['professionalId'],
          'sessionDate': session['sessionDate'],
        })
            .toList();
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load sessions');
    }
  }


  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(item) {
    throw UnimplementedError();
  }
}