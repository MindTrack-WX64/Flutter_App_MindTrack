import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/services/base_service.dart';

class SessionService extends BaseService {
  SessionService() : super(resourceEndPoint: '/sessions');

  Future<http.Response> createSession(Map<String, dynamic> sessionData, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(sessionData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create session');
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
      final session = json.decode(response.body);
      if (session.isNotEmpty) {
        return session[0];
      } else {
        throw Exception('No sessions found for patient');
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