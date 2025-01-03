import 'package:flutter_template/model/local/domain/entity/example.dart';
import 'package:flutter_template/model/local/error/errors.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<Hello, RepositoryErr>> find(int id);
}
