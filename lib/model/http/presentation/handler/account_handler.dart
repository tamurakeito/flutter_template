import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/http/usecase/account.dart';
import 'package:flutter_template/utils/result.dart';

class AccountHandler {
  final AccountUsecase accountUsecase;
  AccountHandler(this.accountUsecase);

  Future<Result<SignInResponse, HttpErr>> signIn(SignInRequest request) async {
    return accountUsecase.signIn(request);
  }

  Future<Result<SignUpResponse, HttpErr>> signUp(SignUpRequest request) async {
    return accountUsecase.signUp(request);
  }
}
