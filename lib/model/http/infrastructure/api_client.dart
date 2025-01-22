import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({
    required this.baseUrl,
    required this.client,
  });

  Future<http.Response> clientRequest(String path,
      {String method = 'GET', Map<String, dynamic>? data}) async {
    var uri = Uri.parse('$baseUrl$path');

    // await Future.delayed(Duration(milliseconds: 500));

    switch (method.toUpperCase()) {
      case 'POST':
        return client.post(uri,
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'});
      case 'PUT':
        return client.put(uri,
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'});
      case 'DELETE':
        return client.delete(uri);
      case 'GET':
      default:
        return client.get(uri);
    }
  }
}
