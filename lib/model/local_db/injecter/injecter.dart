import 'package:flutter_template/model/local_db/domain/repository/example.dart';
import 'package:flutter_template/model/local_db/infrastructure/database/database_handler.dart';
import 'package:flutter_template/model/local_db/infrastructure/example.dart';
import 'package:flutter_template/model/local_db/presentation/handler/example_handler.dart';
import 'package:flutter_template/model/local_db/usecase/example.dart';

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
