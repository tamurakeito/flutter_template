import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/infrastructure/api_client.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:http/http.dart' as http;

class HelloRepositoryImpl implements HelloRepository {
  final String baseUrl;
  final http.Client client;
  final ApiClient apiClient;

  HelloRepositoryImpl({
    required this.baseUrl,
    required this.client,
  }) : apiClient = ApiClient(baseUrl: baseUrl, client: client);

  @override
  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id) async {
    try {
      final response = await apiClient.clientRequest('/hello-world/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final helloWorld = HelloWorld.fromJson(data);
        return Result(data: helloWorld, error: null);
      } else if (response.statusCode == 400) {
        return Result(
          data: null,
          error: HttpError.badRequest,
        );
      } else if (response.statusCode == 401) {
        return Result(
          data: null,
          error: HttpError.unauthorized,
        );
      } else if (response.statusCode == 404) {
        return Result(
          data: null,
          error: HttpError.notFound,
        );
      } else if (response.statusCode == 500) {
        return Result(
          data: null,
          error: HttpError.internalError,
        );
      } else if (response.statusCode == 503) {
        return Result(
          data: null,
          error: HttpError.serviceUnavailabe,
        );
      } else {
        return Result(
          data: null,
          error: HttpError.unknownError,
        );
      }
    } on SocketException {
      return Result(
        data: null,
        error: HttpError.networkUnavailable,
      );
    } on TimeoutException {
      return Result(
        data: null,
        error: HttpError.timeout,
      );
    } on FormatException {
      return Result(
        data: null,
        error: HttpError.invalidResponseFormat,
      );
    } catch (e) {
      log(
        "[Error]http.HelloRepositoryImpl.find",
        error: e,
      );
      return Result(
        data: null,
        error: HttpError.unknownError,
      );
    }
  }
}
