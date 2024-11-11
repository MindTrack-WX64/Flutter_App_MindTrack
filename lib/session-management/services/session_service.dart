import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/services/base_service.dart';
import '../model/session_entity.dart';

class SessionService extends BaseService<SessionEntity> {
  SessionService() : super(resourceEndpoint: '/sessions');

  Future<http.Response> createSession(Map<String, dynamic> sessionData, String token) async {
    // Convert the Map to JSON
    final sessionJson = json.encode(sessionData);

    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: sessionJson,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create a session');
    }
    return response;
  }

  Future<List<SessionEntity>> findByPatientId(int patientId, String token) async {
    print('$apiUrl$resourceEndpoint?patientId=$patientId');
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint?patientId=$patientId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final sessions = json.decode(response.body) as List;
        return sessions.map((session) => fromJson(session)).toList();
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<List<SessionEntity>> findByProfessionalId(int professionalId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/professional/$professionalId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final sessions = json.decode(response.body) as List;
        return sessions.map((session) => fromJson(session)).toList();
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  @override
  SessionEntity fromJson(Map<String, dynamic> json) {
    return SessionEntity.fromJson(json);  // Utilizando el método de fábrica de SessionEntity
  }

  @override
  Map<String, dynamic> toJson(SessionEntity item) {
    return item.toJson();  // Usando el método toJson del objeto SessionEntity
  }
}
