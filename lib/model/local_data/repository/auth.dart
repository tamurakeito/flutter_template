import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/utils/result.dart';

abstract class AuthRepository {
  Future<LocalDataErr?> storeUser(User user);
  Future<Result<User, LocalDataErr>> loadUser();
  Future<LocalDataErr?> removeUser();
}
