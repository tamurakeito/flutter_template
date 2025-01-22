import 'dart:async';
import 'dart:io';
import 'package:flutter_template/domain/entity/account.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/account.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'example_test.mocks.dart';

@GenerateMocks([http.Client]) // モック生成対象を指定
void main() {
  late MockClient mockHttpClient;
  late AccountRepositoryImpl repository;

  const baseUrl = 'https://example.com/api';

  setUp(() {
    mockHttpClient = MockClient();
    repository =
        AccountRepositoryImpl(baseUrl: baseUrl, client: mockHttpClient);
  });

  group('AccountRepositoryImpl.signIn', () {
    test('Returns SignInResponse when response is 200', () async {
      const userId = "validUser";
      const password = "validPassword";
      const id = 1;
      const name = "valid user";
      const token = "validToken";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };
      final mockResponse = {
        'id': id,
        'user_id': userId,
        'name': name,
        'token': token,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await repository.signIn(data);

      expect(result.data, isA<SignInResponse>());
      expect(result.data?.id, id);
      expect(result.data?.userId, userId);
      expect(result.data?.name, name);
      expect(result.data?.token, token);
      expect(result.error, isNull);
    });

    test('Returns HttpError.badRequest when response is 400', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Request was invalid', 400));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.badRequest);
    });

    test('Returns HttpError.notFound when response is 404', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Resouce Not Found', 404));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.notFound);
    });

    test('Returns HttpError.internalError when response is 500', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Internal server error', 500));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.internalError);
    });

    test('Returns HttpError.serviceUnavailabe when response is 503', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Error: Service temporarily unavailabe', 503));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.serviceUnavailabe);
    });

    test('Returns HttpError.unknowError when response is unexpected', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Unknown error occured', 999));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });

    test('Handles network errors (SocketException)', () async {
      const userId = "validUser";
      const password = "validPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.networkUnavailable);
    });

    test('Handles timeout errors (TimeoutException)', () async {
      const userId = "validUser";
      const password = "validPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(TimeoutException('Connection timed out'));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.timeout);
    });

    test('Handles unexpected errors', () async {
      const userId = "validUser";
      const password = "validPassword";
      final data = SignInRequest(
        userId: userId,
        password: password,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-in'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(Exception('Unexpected error'));

      final result = await repository.signIn(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });
  });

  group('AccountRepositoryImpl.signUp', () {
    test('Returns SignUpResponse when response is 200', () async {
      const userId = "validUser";
      const password = "validPassword";
      const name = "valid user";
      const id = 1;
      const token = "validToken";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };
      final mockResponse = {
        'id': id,
        'user_id': userId,
        'name': name,
        'token': token,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await repository.signUp(data);

      expect(result.data, isA<SignUpResponse>());
      expect(result.data?.id, id);
      expect(result.data?.userId, userId);
      expect(result.data?.name, name);
      expect(result.data?.token, token);
      expect(result.error, isNull);
    });

    test('Returns HttpError.badRequest when response is 400', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Request was invalid', 400));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.badRequest);
    });

    test('Returns HttpError.conflict when response is 409', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Error: Resouce conflict', 409));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.conflict);
    });

    test('Returns HttpError.internalError when response is 500', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Internal server error', 500));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.internalError);
    });

    test('Returns HttpError.serviceUnavailabe when response is 503', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Error: Service temporarily unavailabe', 503));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.serviceUnavailabe);
    });

    test('Returns HttpError.unknownError when response is unexpected',
        () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
          (_) async => http.Response('Error: Unknown error occurred', 999));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });

    test('Handles network errors (SocketException)', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.networkUnavailable);
    });

    test('Handles timeout errors (TimeoutException)', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(TimeoutException('Connection timed out'));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.timeout);
    });

    test('Handles unexpected errors', () async {
      const userId = "invalidUser";
      const password = "invalidPassword";
      const name = "valid user";
      final data = SignUpRequest(
        userId: userId,
        password: password,
        name: name,
      );
      Map<String, dynamic> jsonData = {
        'user_id': userId,
        'password': password,
        'name': name,
      };

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/sign-up'),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      )).thenThrow(Exception('Unexpected error'));

      final result = await repository.signUp(data);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });
  });
}
