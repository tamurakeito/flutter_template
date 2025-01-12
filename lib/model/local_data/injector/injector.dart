import 'package:flutter_template/model/local_data/repository/example.dart';
import 'package:flutter_template/model/local_data/infrastructure/database/database_handler.dart';
import 'package:flutter_template/model/local_data/infrastructure/example.dart';
import 'package:flutter_template/model/local_data/presentation/handler/example_handler.dart';
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

  static HelloworldUsecase injectHelloworldUsecase() {
    final repository = injectHelloRepository();
    return HelloworldUsecase(repository);
  }

  static HelloworldHandler injectHelloworldHandler() {
    final usecase = injectHelloworldUsecase();
    return HelloworldHandler(usecase);
  }
}
