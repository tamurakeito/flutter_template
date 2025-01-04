import 'package:flutter_template/model/local_db/domain/entity/example.dart';
import 'package:flutter_template/model/local_db/usecase/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldHandler {
  final HelloworldUsecase helloUsecase;
  HelloworldHandler(this.helloUsecase);

  Future<Result<HelloWorld, LocalDatabaseErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloworldDetail(id);
  }
}