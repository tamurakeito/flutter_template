import 'dart:developer';

import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/model/local_data/repository/auth.dart';
import 'package:flutter_template/utils/result.dart';

class AuthUsecase {
  final AuthRepository repository;
  AuthUsecase(this.repository);

  Future<LocalDataErr?> storeUser(User user) async {
    try {
      final err = await repository.storeUser(user);
      return err;
    } catch (e) {
      log(
        "[Error]local_data.AuthUsecase.storeUser",
        error: e,
      );
      return LocalDataError.internalError;
    }
  }

  Future<Result<User, LocalDataErr>> loadUser() async {
    try {
      final result = await repository.loadUser();
      final err = result.error;
      if (result.isSuccess) {
        return Result(
          data: result.data,
          error: null,
        );
      } else {
        return Result(
          data: null,
          error: err ?? LocalDataError.internalError,
        );
      }
    } catch (e) {
      log(
        "[Error]local_data.AuthUsecase.loadUser",
        error: e,
      );
      return Result(
        data: null,
        error: LocalDataError.internalError,
      );
    }
  }

  Future<LocalDataErr?> removeUser() async {
    try {
      final err = await repository.removeUser();
      return err;
    } catch (e) {
      log(
        "[Error]local_data.AuthUsecase.removeUser",
        error: e,
      );
      return LocalDataError.internalError;
    }
  }
}
