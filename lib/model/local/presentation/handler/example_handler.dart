import 'package:flutter_template/model/local/domain/entity/example.dart';
import 'package:flutter_template/model/local/error/errors.dart';
import 'package:flutter_template/model/local/usecase/example.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldHandler {
  final HelloworldUsecase helloUsecase;
  HelloworldHandler(this.helloUsecase);

  Future<Result<HelloWorld, UsecaseErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloworldDetail(id);
  }
}
