import 'package:flutter_template/types/example.dart';
import 'package:flutter_template/model/http/usecase/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloWorldHandler {
  final HelloWorldUsecase helloUsecase;
  HelloWorldHandler(this.helloUsecase);

  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloWorldDetail(id);
  }
}
