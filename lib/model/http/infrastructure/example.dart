import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloRepositoryImpl implements HelloRepository {
  final String baseUrl;

  HelloRepositoryImpl(this.baseUrl);

  @override
  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/hello-world/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final helloWorld = HelloWorld.fromJson(data);
        return Result(data: helloWorld, error: null);
      } else if (response.statusCode == 404) {
        return Result(
          data: null,
          error: HttpError.notFound,
        );
      } else {
        return Result(
          data: null,
          error: HttpError.internalError,
        );
      }
    } catch (e) {
      return Result(
        data: null,
        error: HttpError.internalError,
      );
    }
  }
}
