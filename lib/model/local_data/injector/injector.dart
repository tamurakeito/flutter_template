import 'package:flutter_template/model/local_data/infrastructure/auth.dart';
import 'package:flutter_template/model/local_data/presentation/handler/auth_handler.dart';
import 'package:flutter_template/model/local_data/repository/auth.dart';
import 'package:flutter_template/model/local_data/repository/example.dart';
import 'package:flutter_template/model/local_data/infrastructure/database/database_handler.dart';
import 'package:flutter_template/model/local_data/infrastructure/example.dart';
import 'package:flutter_template/model/local_data/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/local_data/usecase/auth.dart';
import 'package:flutter_template/model/local_data/usecase/example.dart';

class Injector {
  static DatabaseHandler injectDB() {
    final handler = DatabaseHandler.instance;
    return handler;
  }

  static HelloRepository injectHelloRepository() {
    final db = injectDB().database;
    return HelloRepositoryImpl(db);
  }

  static AuthRepository injectAuthRepository() {
    final db = injectDB().database;
    return AuthRepositoryImpl(db);
  }

  static HelloworldUsecase injectHelloworldUsecase() {
    final repository = injectHelloRepository();
    return HelloworldUsecase(repository);
  }

  static AuthUsecase injectAuthUsecase() {
    final repository = injectAuthRepository();
    return AuthUsecase(repository);
  }

  static HelloWorldHandler injectHelloWorldHandler() {
    final usecase = injectHelloworldUsecase();
    return HelloWorldHandler(usecase);
  }

  static AuthHandler injectAuthHandler() {
    final usecase = injectAuthUsecase();
    return AuthHandler(usecase);
  }
}
