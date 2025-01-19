import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/model/http/infrastructure/example.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/http/usecase/example.dart';
import 'package:http/http.dart' as http;

class Injector {
  static http.Client injectHttpClient() {
    return http.Client();
  }

  static HelloRepository injectHelloRepository() {
    const baseUrl = "http://localhost:3004";
    final client = injectHttpClient();
    return HelloRepositoryImpl(baseUrl: baseUrl, client: client);
  }

  static HelloworldUsecase injectHelloworldUsecase() {
    final repository = injectHelloRepository();
    return HelloworldUsecase(repository);
  }

  static HelloworldHandler injectHelloworldHandler() {
    final usecase = injectHelloworldUsecase();
    return HelloworldHandler(usecase);
  }
}
