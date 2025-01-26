import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client client;
  final String? token;

  ApiClient({
    required this.baseUrl,
    required this.client,
    this.token,
  });

  Future<http.Response> clientRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
  }) async {
    var uri = Uri.parse('$baseUrl$path');

    switch (method.toUpperCase()) {
      case 'POST':
        return client.post(
          uri,
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      case 'PUT':
        return client.put(
          uri,
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      case 'DELETE':
        return client.delete(
          uri,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
      case 'GET':
      default:
        return client.get(
          uri,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
    }
  }
}
