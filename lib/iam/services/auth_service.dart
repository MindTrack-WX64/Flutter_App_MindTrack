import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/model/user_entity.dart';
import '../../shared/services/base_service.dart';

class AuthService extends BaseService<User> {
  AuthService() : super(resourceEndpoint: '/authentication/sign-in');

  Future<Map<String, dynamic>> authenticate(User user) async {
    final userJson = json.encode(user.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl$resourceEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: userJson,
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];
      final userId = responseBody['id'];
      final roles = responseBody['roles'];
      print(token);
      return {'token': token, 'userId': userId as int, 'roles': roles};
    } else {
      throw Exception('Failed to authenticate');
    }
  }





  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(User item) {
    return item.toJson();
  }
}