import 'package:flutter_template/model/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<HelloWorld, HttpErr>> helloWorldDetail(int id);
}
