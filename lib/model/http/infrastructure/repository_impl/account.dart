import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/http/infrastructure/api_client.dart';
import 'package:flutter_template/model/http/repository/account.dart';
import 'package:flutter_template/utils/result.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ApiClient client;

  AccountRepositoryImpl({
    required this.client,
  });

  @override
  Future<Result<SignInResponse, HttpErr>> signIn(SignInRequest data) async {
    try {
      Map<String, dynamic> jsonData = {
        'user_id': data.userId,
        'password': data.password,
      };

      final response = await client.clientRequest(
        '/sign-in',
        method: 'POST',
        data: jsonData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final signInResponse = SignInResponse.fromJson(data);
        return Result(data: signInResponse, error: null);
      } else if (response.statusCode == 400) {
        return Result(
          data: null,
          error: HttpError.badRequest,
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
        "[Error]http.AccountRepositoryImpl.signIn",
        error: e,
      );
      return Result(
        data: null,
        error: HttpError.unknownError,
      );
    }
  }

  @override
  Future<Result<SignUpResponse, HttpErr>> signUp(SignUpRequest data) async {
    try {
      Map<String, dynamic> jsonData = {
        'user_id': data.userId,
        'password': data.password,
        'name': data.name,
      };

      final response = await client.clientRequest(
        '/sign-up',
        method: 'POST',
        data: jsonData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final signUpResponse = SignUpResponse.fromJson(data);
        return Result(data: signUpResponse, error: null);
      } else if (response.statusCode == 400) {
        return Result(
          data: null,
          error: HttpError.badRequest,
        );
      } else if (response.statusCode == 409) {
        return Result(
          data: null,
          error: HttpError.conflict,
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
        "[Error]http.AccountRepositoryImpl.signUp",
        error: e,
      );
      return Result(
        data: null,
        error: HttpError.unknownError,
      );
    }
  }
}
