import 'package:flutter_template/model/local/domain/repository/example.dart';
import 'package:flutter_template/model/local/infrastructure/database/database_handler.dart';
import 'package:flutter_template/model/local/infrastructure/example.dart';
import 'package:flutter_template/model/local/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/local/usecase/example.dart';

class Injector {
  static DatabaseHandler injectDB() {
    final handler = DatabaseHandler.instance;
    return handler;
  }

  static HelloRepository injectHelloRepository() {
    final db = injectDB().database;
    return HelloRepositoryImpl(db);
  }

  static HelloworldUsecase injectHelloUsecase() {
    final repository = injectHelloRepository();
    return HelloworldUsecase(repository);
  }

  static HelloworldHandler injectHelloHandler() {
    final usecase = injectHelloUsecase();
    return HelloworldHandler(usecase);
  }
}
