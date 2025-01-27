import 'dart:async';
import 'dart:io';
import 'package:flutter_template/model/http/infrastructure/api_client.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_template/types/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'example_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late HelloRepositoryImpl repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = HelloRepositoryImpl(client: mockApiClient);
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

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isA<HelloWorld>());
      expect(result.data?.id, id);
      expect(result.data?.hello.name, 'hello, world!');
      expect(result.error, isNull);
    });

    test('Returns HttpError.badRequest when response is 400', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response('Error: Request was invalid', 400));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.badRequest);
    });

    test('Returns HttpError.unauthorized when response is 401', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response('Error: Not authorized to access', 401));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.unauthorized);
    });

    test('Returns HttpError.notFound when response is 404', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response('Error: Resouce Not Found', 404));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.notFound);
    });

    test('Returns HttpError.internal when response is 500', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response('Error: Internal server error', 500));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.internalError);
    });

    test('Returns HttpError.serviceUnavailabe when response is 503', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async =>
              http.Response('Error: Service temporaroly unavailabe', 503));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.serviceUnavailabe);
    });

    test('Returns HttpError.unknowError when response is unexpected', () async {
      const id = 999;

      when(mockApiClient.clientRequest('/hello-world/$id')).thenAnswer(
          (_) async => http.Response('Error: Unknown error occurred', 999));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });

    test('Handles network errors (SocketException)', () async {
      const id = 1;

      when(mockApiClient.clientRequest('/hello-world/$id'))
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.networkUnavailable);
    });

    test('Handles timeout errors (TimeoutException)', () async {
      const id = 1;

      when(mockApiClient.clientRequest('/hello-world/$id'))
          .thenThrow(TimeoutException('Connection timed out'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.timeout);
    });

    test('Handles unexpected errors', () async {
      const id = 1;

      when(mockApiClient.clientRequest('/hello-world/$id'))
          .thenThrow(Exception('Unexpected error'));

      final result = await repository.helloWorldDetail(id);

      expect(result.data, isNull);
      expect(result.error, HttpError.unknownError);
    });
  });
}
