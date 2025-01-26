import 'package:flutter_template/flavors.dart';
import 'package:flutter_template/model/http/infrastructure/api_client.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/account.dart';
import 'package:flutter_template/model/http/presentation/handler/account_handler.dart';
import 'package:flutter_template/model/http/repository/account.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/model/http/infrastructure/repository_impl/example.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/http/usecase/account.dart';
import 'package:flutter_template/model/http/usecase/example.dart';
import 'package:flutter_template/view_model/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class Injector {
  static http.Client injectHttpClient() {
    return http.Client();
  }

  static ApiClient injectApiClient({Ref? ref}) {
    final baseUrl = F.apiBaseUrl;
    final client = injectHttpClient();
    final token = ref?.watch(tokenProvider);
    return ApiClient(
      baseUrl: baseUrl,
      client: client,
      token: token,
    );
  }

  // Repository injection

  static HelloRepository injectHelloRepository(Ref ref) {
    final client = injectApiClient(ref: ref);
    return HelloRepositoryImpl(client: client);
  }

  static AccountRepository injectAccountRepository() {
    final client = injectApiClient();
    return AccountRepositoryImpl(client: client);
  }

  // Usecase injection

  static HelloWorldUsecase injectHelloWorldUsecase(Ref ref) {
    final repository = injectHelloRepository(ref);
    return HelloWorldUsecase(repository);
  }

  static AccountUsecase injectAccountUsecase() {
    final repository = injectAccountRepository();
    return AccountUsecase(repository);
  }

  // Handler injection

  static HelloWorldHandler injectHelloWorldHandler(Ref ref) {
    final usecase = injectHelloWorldUsecase(ref);
    return HelloWorldHandler(usecase);
  }

  static AccountHandler injectAccountHandler() {
    final usecase = injectAccountUsecase();
    return AccountHandler(usecase);
  }
}
