import '../model/professional_entity.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base_service.dart';

class ProfessionalService extends BaseService<Professional> {
  ProfessionalService() : super(resourceEndpoint: '/professionals');

  @override
  Professional fromJson(Map<String, dynamic> json) {
    return Professional.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Professional item) {
    return item.toJson();
  }

  Future<String> getProfessionalNameById(int userId, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl$resourceEndpoint/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['fullName']);
      return data['fullName'];
    } else {
      throw Exception('Failed to load patient name');
    }
  }

}