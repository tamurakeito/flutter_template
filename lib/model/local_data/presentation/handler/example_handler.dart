import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/local_data/usecase/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloWorldHandler {
  final HelloworldUsecase helloUsecase;
  HelloWorldHandler(this.helloUsecase);

  Future<Result<HelloWorld, LocalDataErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloworldDetail(id);
  }
}
