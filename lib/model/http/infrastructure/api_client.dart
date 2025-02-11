import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client client;
  String? token;

  ApiClient({
    required this.baseUrl,
    required this.client,
    this.token,
  });

  // // トークンを更新するメソッド
  // void updateToken(String newToken) {
  //   token = newToken;
  // }

  Future<http.Response> clientRequest(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
    bool useAuth = true,
  }) async {
    var uri = Uri.parse('$baseUrl$path');

    final headers = {
      'Content-Type': 'application/json',
      if (useAuth && token != null) 'Authorization': 'Bearer $token',
    };

    switch (method.toUpperCase()) {
      case 'POST':
        return client.post(uri, body: jsonEncode(data), headers: headers);
      case 'PUT':
        return client.put(uri, body: jsonEncode(data), headers: headers);
      case 'DELETE':
        return client.delete(uri, headers: headers);
      case 'GET':
      default:
        return client.get(uri, headers: headers);
    }
  }
}
