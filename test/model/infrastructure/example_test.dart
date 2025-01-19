import 'dart:async';
import 'dart:io';
import 'package:flutter_template/model/http/infrastructure/example.dart';
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
  late HelloRepositoryImpl repository;

  const baseUrl = 'https://example.com/api';

  setUp(() {
    mockHttpClient = MockClient();
    repository = HelloRepositoryImpl(baseUrl: baseUrl, client: mockHttpClient);
  });

  group('HelloRepositoryImpl', () {
    test('Returns HelloWorld when response is 200', () async {
      const id = 1;
      final mockResponse = {
        'id': id,
        'hello': {
          'id': id,
          'name': 'hello, world!',
          'tag': true,
        }
      };

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isA<HelloWorld>());
      expect(result.data?.id, id);
      expect(result.data?.hello.name, 'hello, world!');
      expect(result.error, isNull);
    });

    test('Returns HttpError.notFound when response is 404', () async {
      const id = 999;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenAnswer(
              (_) async => http.Response('Error: Resouce Not Found', 404));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.notFound);
    });

    test('Returns HttpError.notFound when response is 401', () async {
      const id = 999;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenAnswer((_) async =>
              http.Response('Error: Not authorized to access', 401));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.unauthorized);
    });

    test('Returns HttpError.notFound when response is 403', () async {
      const id = 999;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenAnswer((_) async => http.Response(
              'Error: Access to this resource is forbidden', 403));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.forbidden);
    });

    test('Handles network errors (SocketException)', () async {
      const id = 1;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.networkUnavailable);
    });

    test('Handles timeout errors (TimeoutException)', () async {
      const id = 1;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenThrow(TimeoutException('Connection timed out'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.timeout);
    });

    test('Handles unexpected errors', () async {
      const id = 1;

      when(mockHttpClient.get(Uri.parse('$baseUrl/hello-world/$id')))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.internalError);
    });
  });
}
