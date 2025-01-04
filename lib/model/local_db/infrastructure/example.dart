import 'dart:developer';

import 'package:flutter_template/model/local_db/domain/entity/example.dart';
import 'package:flutter_template/model/local_db/domain/repository/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class HelloRepositoryImpl implements HelloRepository {
  final Database _db;
  HelloRepositoryImpl(this._db);

  @override
  Future<Result<Hello, LocalDatabaseErr>> find(int id) async {
    try {
      final result = await _db.query(
        'hello_world',
        columns: ['id', 'name', 'tag'],
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Result(
          data: Hello(
            id: row['id'] as int,
            name: row['name'] as String,
            tag: row['tag'] == 1,
          ),
          error: null,
        );
      } else {
        return Result(
          data: null,
          error: LocalDatabaseError.notFound,
        );
      }
    } catch (e) {
      log(
        "[Error]HelloRepositoryImpl.find",
        error: e,
      );
      return Result(
        data: null,
        error: LocalDatabaseError.databaseError,
      );
    }
  }
}
