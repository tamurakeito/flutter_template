import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/model/http/infrastructure/example.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/http/usecase/example.dart';

class Injector {
  static HelloRepository injectHelloRepository() {
    const baseUrl = "http://localhost:3004";
    return HelloRepositoryImpl(baseUrl);
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
