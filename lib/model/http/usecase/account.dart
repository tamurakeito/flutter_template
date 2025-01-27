import 'package:flutter_template/types/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/http/repository/account.dart';
import 'package:flutter_template/utils/result.dart';

class AccountUsecase {
  final AccountRepository repository;
  AccountUsecase(this.repository);

  Future<Result<SignInResponse, HttpErr>> signIn(SignInRequest request) async {
    return repository.signIn(request);
  }

  Future<Result<SignUpResponse, HttpErr>> signUp(SignUpRequest request) async {
    return repository.signUp(request);
  }
}
