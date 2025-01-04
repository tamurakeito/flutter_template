import 'package:flutter_template/model/local_db/domain/entity/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class HelloRepository {
  Future<Result<Hello, LocalDatabaseErr>> find(int id);
}
