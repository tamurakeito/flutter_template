import 'dart:developer';
import 'package:flutter_template/domain/entity/example.dart';
import 'package:flutter_template/model/local_data/injector/injector.dart';
import 'package:flutter_template/model/local_data/presentation/handler/example_handler.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalDataViewModelState {
  final bool isLoading;
  final String? errorMessage;

  LocalDataViewModelState({
    this.isLoading = false,
    this.errorMessage,
  });

  LocalDataViewModelState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocalDataViewModelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LocalDataViewModel extends StateNotifier<LocalDataViewModelState> {
  final HelloworldHandler _helloworldHandler;
  LocalDataViewModel(this._helloworldHandler)
      : super(LocalDataViewModelState());

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

final helloworldHandlerProvider =
    Provider<HelloworldHandler>((ref) => Injector.injectHelloworldHandler());

final localDataViewModelProvider =
    StateNotifierProvider<LocalDataViewModel, LocalDataViewModelState>(
  (ref) {
    final helloworldHandler = ref.read(helloworldHandlerProvider);
    return LocalDataViewModel(helloworldHandler);
  },
);
