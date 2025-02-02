import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/model/local_data/usecase/auth.dart';
import 'package:flutter_template/utils/result.dart';

class AuthHandler {
  final AuthUsecase authUsecase;
  AuthHandler(this.authUsecase);

  Future<LocalDataErr?> storeUser(User user) async {
    return authUsecase.storeUser(user);
  }

  Future<Result<User, LocalDataErr>> loadUser() async {
    return authUsecase.loadUser();
  }

  Future<LocalDataErr?> removeUser() async {
    return authUsecase.removeUser();
  }
}
