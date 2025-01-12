import 'dart:developer';
import 'package:flutter_template/entity/example.dart';
import 'package:flutter_template/model/http/injector/injector.dart';
import 'package:flutter_template/model/http/presentation/handler/example_handler.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HttpViewModelState {
  final bool isLoading;

  HttpViewModelState({this.isLoading = false});

  HttpViewModelState copyWith({bool? isLoading}) {
    return HttpViewModelState(isLoading: isLoading ?? this.isLoading);
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
          // case HttpError.databaseError:
          //   message = "ストレージへのアクセスに失敗しました";
          //   break;
          case HttpError.internalError:
            message = "サーバーでエラーが発生しました。";
            break;
          default:
            message = "That won't rearch here.";
        }
        state = state.copyWith(isLoading: false);
        return Result(data: null, error: Err(message: message));
      }
    } catch (e) {
      log(
        "[Error]HttpViewModel.fetchHelloworldDetail",
        error: e,
      );
      state = state.copyWith(isLoading: false);
      return Result(
        data: null,
        error: const Err(message: "システムに予期しないエラーが発生しました"),
      );
    }
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
