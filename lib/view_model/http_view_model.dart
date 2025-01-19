import 'dart:developer';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/injector/injector.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HttpViewModelState {
  final bool isLoading;
  final String? errorMessage;

  HttpViewModelState({
    this.isLoading = false,
    this.errorMessage,
  });

  HttpViewModelState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return HttpViewModelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HttpViewModel extends StateNotifier<HttpViewModelState> {
  final HelloworldHandler _helloworldHandler;
  HttpViewModel(this._helloworldHandler) : super(HttpViewModelState());

  Future<Result<HelloWorld, Err>> fetchHelloworldDetail(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _helloworldHandler.helloWorldDetail(id);

      if (result.isSuccess) {
        state = state.copyWith(isLoading: false);
        return result;
      } else {
        String message;
        final err = result.error;

        switch (err) {
          case HttpError.notFound:
            message = "データが存在しません";
            break;
          case HttpError.timeout:
            message = "通信がタイムアウトしました";
            break;
          case HttpError.networkUnavailable:
            message = "ネットワーク接続がありません";
            break;
          case HttpError.unauthorized:
            message = "認証に失敗しました";
            break;
          case HttpError.forbidden:
            message = "アクセス権限がありません";
            break;
          case HttpError.internalError:
            message = "サーバーでエラーが発生しました";
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
        "[Error]HttpViewModel.fetchHelloworldDetail",
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

final helloworldHandlerProvider =
    Provider<HelloworldHandler>((ref) => Injector.injectHelloworldHandler());

final httpViewModelProvider =
    StateNotifierProvider<HttpViewModel, HttpViewModelState>(
  (ref) {
    final helloworldHandler = ref.read(helloworldHandlerProvider);
    return HttpViewModel(helloworldHandler);
  },
);
