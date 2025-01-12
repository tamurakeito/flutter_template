import 'package:flutter_template/entity/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<Hello, LocalDataErr>> find(int id);
}
