import 'dart:developer';

import 'package:flutter_template/model/local/domain/entity/example.dart';
import 'package:flutter_template/model/local/domain/repository/example.dart';
import 'package:flutter_template/model/local/error/errors.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldUsecase {
  final HelloRepository repository;
  HelloworldUsecase(this.repository);

  Future<Result<HelloWorld, UsecaseErr>> helloworldDetail(int id) async {
    try {
      final result = await repository.find(id);
      final err = result.error;
      if (err != null) {
        switch (err) {
          case RepositoryError.notFound:
            return Result(
              data: null,
              error: UsecaseError.notFound,
            );
          case RepositoryError.databaseError:
            return Result(
              data: null,
              error: UsecaseError.databaseError,
            );
          default:
            return Result(
              data: null,
              error: UsecaseError.internalError,
            );
        }
      }

      if (result.data == null) {
        return Result(
          data: null,
          error: UsecaseError.internalError,
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
        error: UsecaseError.internalError,
      );
    }
  }
}
