import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloWorldUsecase {
  final HelloRepository repository;
  HelloWorldUsecase(this.repository);

  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id) async {
    return repository.helloWorldDetail(id);
  }
}
