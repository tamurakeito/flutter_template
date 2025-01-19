import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id);
}
