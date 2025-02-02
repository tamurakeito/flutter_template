import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/model/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/http/injector/injector.dart'
    as http_injector;
import 'package:flutter_template/model/local_data/injector/injector.dart'
    as local_injector;
import 'package:flutter_template/model/http/presentation/handler/account_handler.dart';
import 'package:flutter_template/model/local_data/presentation/handler/auth_handler.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_template/view/services/snackbar_service.dart';

class AuthViewModelState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  AuthViewModelState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthViewModelState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthViewModelState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthViewModelState> {
  final AccountHandler _accountHandler;
  final AuthHandler _authHandler;
  final Ref ref;

  AuthViewModel(
    this._accountHandler,
    this._authHandler,
    this.ref,
  ) : super(AuthViewModelState());

  Future<Result<SignInResponse, Err>> fetchSignIn(SignInRequest data) async {
    final startTime = DateTime.now();
    state = state.copyWith(isLoading: true);
    try {
      final result = await _accountHandler.signIn(data);

      // 処理が早く終了した場合でも最低遅延を確保
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime.inMilliseconds < 1000) {
        await Future.delayed(
            Duration(milliseconds: 1000 - elapsedTime.inMilliseconds));
      }

      if (result.isSuccess) {
        final User user = User(
          id: result.data!.id,
          userId: result.data!.userId,
          password: data.password,
          name: result.data!.name,
          token: result.data!.token,
        );
        final err = await _authHandler.storeUser(user);
        if (err != null) {
          // ローカルストレージへの保存に失敗してもエラーは出さない
          log("アカウント情報をローカルストレージに保存できませんでした。");
        }
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
        ref.read(tokenProvider.notifier).updateToken(result.data!.token);
        return result;
      } else {
        String message;
        final err = result.error;

        switch (err) {
          case HttpError.badRequest:
            message = "不正なリクエストです";
            break;
          case HttpError.notFound:
            message = "データが存在しません";
            break;
          case HttpError.internalError:
            message = "サーバーでエラーが発生しました";
            break;
          case HttpError.serviceUnavailabe:
            message = "サーバーのデータベースが一時的に利用できません";
            break;
          case HttpError.networkUnavailable:
            message = "ネットワーク接続がありません";
            break;
          case HttpError.timeout:
            message = "通信がタイムアウトしました";
            break;
          case HttpError.invalidResponseFormat:
            message = "不正なレスポンスを受信しました";
            break;
          default:
            message = "未知のエラーが発生しました"; // That won't rearch here
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
        return Result(
          data: null,
          error: err,
        );
      }
    } catch (e) {
      log(
        "[Error]HttpExampleViewModel.fetchSignIn",
        error: e,
      );
      String message = "システムに予期しないエラーが発生しました";
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
      return Result(
        data: null,
        error: Err(message: message),
      );
    }
  }

  Future<Result<SignUpResponse, Err>> fetchSignUp(SignUpRequest data) async {
    final startTime = DateTime.now();
    state = state.copyWith(isLoading: true);
    try {
      final result = await _accountHandler.signUp(data);

      // 処理が早く終了した場合でも最低遅延を確保
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime.inMilliseconds < 1000) {
        await Future.delayed(
            Duration(milliseconds: 1000 - elapsedTime.inMilliseconds));
      }

      if (result.isSuccess) {
        final User user = User(
          id: result.data!.id,
          userId: result.data!.userId,
          password: data.password,
          name: result.data!.name,
          token: result.data!.token,
        );
        final err = await _authHandler.storeUser(user);
        if (err != null) {
          // ローカルストレージへの保存に失敗してもエラーは出さない
          log("アカウント情報をローカルストレージに保存できませんでした。");
        }
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
        return result;
      } else {
        String message;
        final err = result.error;

        switch (err) {
          case HttpError.badRequest:
            message = "不正なリクエストです";
            break;
          case HttpError.conflict:
            message = "使用できないユーザー名です";
            break;
          case HttpError.internalError:
            message = "サーバーでエラーが発生しました";
            break;
          case HttpError.serviceUnavailabe:
            message = "サーバーのデータベースが一時的に利用できません";
            break;
          case HttpError.networkUnavailable:
            message = "ネットワーク接続がありません";
            break;
          case HttpError.timeout:
            message = "通信がタイムアウトしました";
            break;
          case HttpError.invalidResponseFormat:
            message = "不正なレスポンスを受信しました";
            break;
          default:
            message = "未知のエラーが発生しました"; // That won't rearch here
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
        return Result(
          data: null,
          error: err,
        );
      }
    } catch (e) {
      log(
        "[Error]HttpExampleViewModel.fetchSignUp",
        error: e,
      );
      String message = "システムに予期しないエラーが発生しました";
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
      return Result(
        data: null,
        error: Err(message: message),
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(
      errorMessage: null,
    );
  }

  void clearUser() async {
    final err = await _authHandler.removeUser();
    if (err != null) {
      // ローカルストレージからの削除に失敗してもエラーは出さない
      log("アカウント情報をローカルストレージから削除できませんでした。");
    }
    await Future.delayed(const Duration(milliseconds: 500));
    SnackbarService.showSnackBar(
      'ログアウトしました',
      color: Colors.pink.shade900,
    );
    state = state.copyWith(user: null);
  }
}

final accountHandlerProvider = Provider<AccountHandler>(
    (ref) => http_injector.Injector.injectAccountHandler());

final authHandlerProvider =
    Provider<AuthHandler>((ref) => local_injector.Injector.injectAuthHandler());

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewModelState>(
  (ref) {
    final accountHandler = ref.read(accountHandlerProvider);
    final authHandler = ref.read(authHandlerProvider);
    return AuthViewModel(accountHandler, authHandler, ref);
  },
);

class TokenProvider extends StateNotifier<String?> {
  TokenProvider() : super(null);

  void updateToken(String? token) {
    state = token;
  }

  void clearToken() {
    state = null;
  }
}

final tokenProvider = StateNotifierProvider<TokenProvider, String?>(
  (ref) => TokenProvider(),
);
