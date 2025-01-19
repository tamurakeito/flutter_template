import 'dart:developer';

import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/local_data/repository/example.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldUsecase {
  final HelloRepository repository;
  HelloworldUsecase(this.repository);

  Future<Result<HelloWorld, LocalDataErr>> helloworldDetail(int id) async {
    try {
      final result = await repository.find(id);
      final err = result.error;
      if (err != null) {
        switch (err) {
          case LocalDataError.notFound:
            return Result(
              data: null,
              error: LocalDataError.notFound,
            );
          case LocalDataError.databaseError:
            return Result(
              data: null,
              error: LocalDataError.databaseError,
            );
          default:
            return Result(
              data: null,
              error: LocalDataError.internalError,
            );
        }
      }

      if (result.data == null) {
        return Result(
          data: null,
          error: LocalDataError.internalError,
        );
      }

      final detail = HelloWorld(id: result.data!.id, hello: result.data!);
      return Result(data: detail, error: null);
    } catch (e) {
      log(
        "[Error]HelloWorldUsecase.helloworldDetail",
        error: e,
      );
      return Result(
        data: null,
        error: LocalDataError.internalError,
      );
    }
  }
}
