import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/model/professional_entity.dart';
import '../../shared/services/base_service.dart';

class RegisterService extends BaseService<Professional> {
  RegisterService() : super(resourceEndpoint: '/authentication/sign-up/professional');

  Future<void> register(Professional professional) async {
    final userJson = json.encode(professional.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: userJson,
    );

    if (response.statusCode == 201) {
      print('Registration successful');
    } else {
      throw Exception('Failed to register');
    }
  }

  @override
  Professional fromJson(Map<String, dynamic> json) {
    return Professional.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Professional item) {
    return item.toJson();
  }
}