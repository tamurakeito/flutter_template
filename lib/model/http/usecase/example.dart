import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/repository/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldUsecase {
  final HelloRepository repository;
  HelloworldUsecase(this.repository);

  Future<Result<HelloWorld, HttpErr>> helloworldDetail(int id) async {
    return repository.helloWorldDetail(id);
  }
}
