import 'dart:developer';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/http/injector/injector.dart'
    as http_injector;
import 'package:flutter_template/model/local_data/injector/injector.dart'
    as local_injector;
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart'
    as http;
import 'package:flutter_template/model/local_data/presentation/handler/example_handler.dart'
    as local;
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelloWorldViewModelState {
  final bool isLoading;
  final String? errorMessage;

  HelloWorldViewModelState({
    this.isLoading = false,
    this.errorMessage,
  });

  HelloWorldViewModelState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return HelloWorldViewModelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HelloWorldViewModel extends StateNotifier<HelloWorldViewModelState> {
  final http.HelloWorldHandler _httpHelloWorldHandler;
  final local.HelloWorldHandler _localHelloWorldHandler;
  HelloWorldViewModel(
    this._httpHelloWorldHandler,
    this._localHelloWorldHandler,
  ) : super(HelloWorldViewModelState());

  Future<Result<HelloWorld, Err>> fetchHttpHelloWorldDetail(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _httpHelloWorldHandler.helloWorldDetail(id);

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
        "[Error]HelloWorldViewModel.fetchHelloWorldDetail",
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

  Future<Result<HelloWorld, Err>> fetchLocalHelloWorldDetail(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _localHelloWorldHandler.helloWorldDetail(id);

      if (result.isSuccess) {
        state = state.copyWith(isLoading: false);
        return result;
      } else {
        String message;
        final err = result.error;
        switch (err) {
          case LocalDataError.notFound:
            message = "データが存在しません";
            break;
          case LocalDataError.databaseError:
            message = "ストレージへのアクセスに失敗しました";
            break;
          case LocalDataError.internalError:
            message = "アプリケーションにエラーが発生しました。";
            break;
          default:
            message = "That won't rearch here.";
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
        );
        return Result(
          data: null,
          error: Err(message: message),
        );
      }
    } catch (e) {
      log(
        "[Error]LocalDataViewModel.fetchHelloworldDetail",
        error: e,
      );
      state = state.copyWith(isLoading: false);
      return Result(
        data: null,
        error: const Err(message: "端末内部のデータ取得に予期しないエラーが発生しました"),
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(
      errorMessage: null,
    );
  }
}

final httpHelloWorldHandlerProvider = Provider<http.HelloWorldHandler>(
    (ref) => http_injector.Injector.injectHelloWorldHandler(ref));

final localHelloWorldHandlerProvider = Provider<local.HelloWorldHandler>(
    (ref) => local_injector.Injector.injectHelloWorldHandler());

final helloWorldViewModelProvider =
    StateNotifierProvider<HelloWorldViewModel, HelloWorldViewModelState>(
  (ref) {
    final httpHelloWorldHandler = ref.read(httpHelloWorldHandlerProvider);
    final localHelloWorldHandler = ref.read(localHelloWorldHandlerProvider);
    return HelloWorldViewModel(
      httpHelloWorldHandler,
      localHelloWorldHandler,
    );
  },
);
