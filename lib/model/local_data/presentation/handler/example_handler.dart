import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/local_data/usecase/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldHandler {
  final HelloworldUsecase helloUsecase;
  HelloworldHandler(this.helloUsecase);

  Future<Result<HelloWorld, LocalDataErr>> helloWorldDetail(int id) async {
    return helloUsecase.helloworldDetail(id);
  }
}
