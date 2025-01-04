import 'dart:developer';
import 'package:flutter_template/model/local_db/domain/entity/example.dart';
import 'package:flutter_template/model/local_db/injecter/injecter.dart';
import 'package:flutter_template/model/local_db/presentation/handler/example_handler.dart';
import 'package:flutter_template/utils/error.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataViewModelState {
  final bool isLoading;

  DataViewModelState({
    this.isLoading = false,
  });

  DataViewModelState copyWith({
    dynamic data,
    Err? error,
    bool? isLoading,
  }) {
    return DataViewModelState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DataViewModel extends StateNotifier<DataViewModelState> {
  final HelloworldHandler _helloworldHandler;
  DataViewModel(this._helloworldHandler) : super(DataViewModelState());

  Future<Result<HelloWorld, Err>> fetchHelloworldDetail(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _helloworldHandler.helloWorldDetail(id);

      if (result.isSuccess) {
        return result;
      } else {
        String message;
        final err = result.error;
        switch (err) {
          case LocalDatabaseError.notFound:
            message = "データが存在しません";
            break;
          case LocalDatabaseError.databaseError:
            message = "ストレージへのアクセスに失敗しました";
            break;
          case LocalDatabaseError.internalError:
            message = "アプリケーションにエラーが発生しました。";
            break;
          default:
            message = "That won't rearch here.";
        }
        return Result(data: null, error: Err(message: message));
      }
    } catch (e) {
      log(
        "[Error]DataViewModel.fetchHelloworldDetail",
        error: e,
      );
      return Result(
        data: null,
        error: const Err(message: "端末内部のデータ取得に予期しないエラーが発生しました"),
      );
    }
  }
}

final helloworldHandlerProvider =
    Provider<HelloworldHandler>((ref) => Injector.injectHelloworldHandler());

final dataViewModelProvider =
    StateNotifierProvider<DataViewModel, DataViewModelState>(
  (ref) {
    final helloworldHandler = ref.read(helloworldHandlerProvider);
    return DataViewModel(helloworldHandler);
  },
);
