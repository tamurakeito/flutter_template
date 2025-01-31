import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/types/account.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/model/http/injector/injector.dart';
import 'package:flutter_template/model/http/presentation/handler/account_handler.dart';
import 'package:flutter_template/utils/result.dart';

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
  final Ref ref;

  AuthViewModel(this._accountHandler, this.ref) : super(AuthViewModelState());

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
          name: result.data!.name,
        );
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
          name: result.data!.name,
        );
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

  void clearUser() {
    state = state.copyWith(user: null);
  }
}

final accountHandlerProvider =
    Provider<AccountHandler>((ref) => Injector.injectAccountHandler());

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewModelState>(
  (ref) {
    final accountHandler = ref.read(accountHandlerProvider);
    return AuthViewModel(accountHandler, ref);
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
