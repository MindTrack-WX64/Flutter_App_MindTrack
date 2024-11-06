import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseService<T> {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1';
  String resourceEndPoint;

  BaseService({this.resourceEndPoint = 'default-endpoint'});

  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse('$apiUrl$resourceEndPoint'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => fromJson(model)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> getById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$resourceEndPoint/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> create(T item, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$resourceEndPoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(toJson(item)),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create item');
    }
    return response;
  }

  Future<void> update(String id, T item) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$resourceEndPoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toJson(item)),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$resourceEndPoint/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);
}