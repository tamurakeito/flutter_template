import 'package:flutter_template/entity/example.dart';
import 'package:flutter_template/model/http/usecase/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldHandler {
  final HelloworldUsecase helloUsecase;
  HelloworldHandler(this.helloUsecase);

  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloworldDetail(id);
  }
}
