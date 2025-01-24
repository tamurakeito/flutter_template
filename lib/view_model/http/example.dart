import 'dart:developer';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/injector/injector.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HttpHelloWorldViewModelState {
  final bool isLoading;
  final String? errorMessage;

  HttpHelloWorldViewModelState({
    this.isLoading = false,
    this.errorMessage,
  });

  HttpHelloWorldViewModelState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return HttpHelloWorldViewModelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HttpHelloWorldViewModel
    extends StateNotifier<HttpHelloWorldViewModelState> {
  final HelloWorldHandler _helloWorldHandler;
  HttpHelloWorldViewModel(this._helloWorldHandler)
      : super(HttpHelloWorldViewModelState());

  Future<Result<HelloWorld, Err>> fetchHelloWorldDetail(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _helloWorldHandler.helloWorldDetail(id);

      if (result.isSuccess) {
        state = state.copyWith(isLoading: false);
        return result;
      } else {
        String message;
        final err = result.error;

        switch (err) {
          case HttpError.badRequest:
            message = "不正なリクエストです";
            break;
          case HttpError.unauthorized:
            message = "認証に失敗しました";
            break;
          // case HttpError.forbidden:
          //   message = "アクセス権限がありません";
          //   break;
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
        "[Error]HttpHelloWorldViewModel.fetchHelloWorldDetail",
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
}

final helloWorldHandlerProvider =
    Provider<HelloWorldHandler>((ref) => Injector.injectHelloWorldHandler());

final httpHelloWorldViewModelProvider = StateNotifierProvider<
    HttpHelloWorldViewModel, HttpHelloWorldViewModelState>(
  (ref) {
    final helloWorldHandler = ref.read(helloWorldHandlerProvider);
    return HttpHelloWorldViewModel(helloWorldHandler);
  },
);
