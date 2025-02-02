import 'dart:developer';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/model/local_data/repository/auth.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Database _db;
  AuthRepositoryImpl(this._db);

  @override
  Future<LocalDataErr?> storeUser(User user) async {
    try {
      await _db.insert(
        'account',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return null;
    } catch (e) {
      log(
        "[Error]local_data.AuthRepositoryImpl.storeUser",
        error: e,
      );
      return LocalDataError.databaseError;
    }
  }

  @override
  Future<Result<User, LocalDataErr>> loadUser() async {
    try {
      final result = await _db.query(
        'account',
        columns: ['id', 'user_id', 'password', 'name', 'token'],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Result(
          data: User.fromJson(row),
          error: null,
        );
      } else {
        return Result(
          data: null,
          error: LocalDataError.notFound,
        );
      }
    } catch (e) {
      log(
        "[Error]local_data.AuthRepositoryImple.loadUser",
        error: e,
      );
      return Result(
        data: null,
        error: LocalDataError.databaseError,
      );
    }
  }

  @override
  Future<LocalDataErr?> removeUser() async {
    try {
      final deletedCount = await _db.delete('account');
      if (deletedCount > 0) {
        return null;
      } else {
        return LocalDataError.notFound;
      }
    } catch (e) {
      log(
        "[Error]local_data.AuthRepositoryImpl.removeUser",
        error: e,
      );
      return LocalDataError.databaseError;
    }
  }
}
