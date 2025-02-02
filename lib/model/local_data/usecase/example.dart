import 'dart:developer';

import 'package:flutter_template/model/example.dart';
import 'package:flutter_template/model/local_data/repository/example.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

class HelloworldUsecase {
  final HelloRepository repository;
  HelloworldUsecase(this.repository);

  Future<Result<HelloWorld, LocalDataErr>> helloworldDetail(int id) async {
    try {
      final result = await repository.find(id);
      final err = result.error;
      if (result.isSuccess) {
        final detail = HelloWorld(id: result.data!.id, hello: result.data!);
        return Result(
          data: detail,
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
