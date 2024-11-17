import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() => message;
}

abstract class BaseService<T> {
  final String apiUrl = 'https://mindtrackbackend-dgh8e0bxhucbhebg.canadacentral-01.azurewebsites.net/api/v1';
  final String resourceEndpoint;
  BaseService({required this.resourceEndpoint});

  /// Fetches a list of resources from the API endpoint.
  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse('$apiUrl/$resourceEndpoint'));
    _handleResponse(response);
    final data = json.decode(response.body) as List<dynamic>;
    return data.map((model) => fromJson(model)).toList();
  }

  /// Fetches a specific resource by ID from the API endpoint.
  /// Requires an authorization token for protected resources.
  Future<T> getById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$resourceEndpoint/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    _handleResponse(response);
    return fromJson(json.decode(response.body));
  }

  /// Creates a new resource on the API endpoint.
  /// Requires an authorization token for protected resources.
  Future<T> create(T item, String token) async {
    print(json.encode(toJson(item)));
    print(resourceEndpoint);
    final response = await http.post(
      Uri.parse('$apiUrl/$resourceEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(toJson(item)),
    );
    _handleResponse(response);
    return fromJson(json.decode(response.body));
  }

  /// Updates an existing resource on the API endpoint.
  Future<T> update(String id, T item, String token) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$resourceEndpoint/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(toJson(item)),
    );
    _handleResponse(response);
    return fromJson(json.decode(response.body));
  }

  /// Deletes a resource from the API endpoint.
  Future<void> delete(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$resourceEndpoint/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    _handleResponse(response);
  }

  /// Handles HTTP responses, throwing an `HttpException` for errors.
  void _handleResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw HttpException('${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Abstract method to convert a JSON object to a specific type T.
  /// This needs to be implemented by the concrete service class.
  T fromJson(Map<String, dynamic> json);

  /// Abstract method to convert a specific type T to a JSON object.
  /// This needs to be implemented by the concrete service class.
  Map<String, dynamic> toJson(T item);
}
