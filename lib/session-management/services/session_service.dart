import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/services/base_service.dart';
import '../model/session_entity.dart';

class SessionService extends BaseService {
  SessionService() : super(this.resourceEndpoint: '/sessions');

  Future<http.Response> createSession(SessionEntity session, String token) async {
    /*final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(session),
    );


*/

    print(session.toJson());
/*    if (response.statusCode != 201) {
      print("failed to create session");
      throw Exception('Failed to create session');

    }
    return response;*/
    return http.Response('{"id": 1}', 201);

  }

  Future<List<SessionEntity>> findByPatientId(int patientId, String token) async {
    print('$apiUrl$resourceEndPoint?patientId=$patientId');
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final sessions = json.decode(response.body);

        if (sessions.isNotEmpty) {
          return sessions;
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

  Future<List<SessionEntity>> findByProfessionalId(int professionalId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndPoint/professional/$professionalId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final sessions = json.decode(response.body);
        return sessions;
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