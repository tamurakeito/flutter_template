import 'package:flutter_template/types/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<Hello, LocalDataErr>> find(int id);
}
