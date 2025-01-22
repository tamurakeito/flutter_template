import 'package:flutter_template/domain/entity/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';

abstract class AccountRepository {
  Future<Result<SignInResponse, HttpErr>> signIn(SignInRequest request);
  Future<Result<SignUpResponse, HttpErr>> signUp(SignUpRequest request);
}
