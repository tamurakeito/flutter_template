import 'package:flutter_template/model/http/infrastructure/repository_impl/account.dart';
import 'package:flutter_template/model/http/presentation/handler/account_handler.dart';
import 'package:flutter_template/model/http/repository/account.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/example.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/http/usecase/account.dart';
import 'package:flutter_template/model/http/usecase/example.dart';
import 'package:http/http.dart' as http;

class Injector {
  static http.Client injectHttpClient() {
    return http.Client();
  }

  // Repository injection

  static HelloRepository injectHelloRepository() {
    const baseUrl = "http://localhost:3004";
    final client = injectHttpClient();
    return HelloRepositoryImpl(baseUrl: baseUrl, client: client);
  }

  static AccountRepository injectAccountRepository() {
    const baseUrl = "http://localhost:3004";
    final client = injectHttpClient();
    return AccountRepositoryImpl(baseUrl: baseUrl, client: client);
  }

  // Usecase injection

  static HelloWorldUsecase injectHelloWorldUsecase() {
    final repository = injectHelloRepository();
    return HelloWorldUsecase(repository);
  }

  static AccountUsecase injectAccountUsecase() {
    final repository = injectAccountRepository();
    return AccountUsecase(repository);
  }

  // Handler injection

  static HelloWorldHandler injectHelloWorldHandler() {
    final usecase = injectHelloWorldUsecase();
    return HelloWorldHandler(usecase);
  }

  static AccountHandler injectAccountHandler() {
    final usecase = injectAccountUsecase();
    return AccountHandler(usecase);
  }
}
