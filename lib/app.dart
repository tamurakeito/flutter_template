import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/view/router.dart';
import 'package:flutter_template/view/services/snackbar_service.dart';
import 'package:flutter_template/view_model/auth.dart';
import 'flavors.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authInit = ref.watch(authInitializerProvider);
    if (authInit.isLoading) {
      // ユーザーデータをロード中のためローディング画面を表示
      return MaterialApp(
        title: F.title,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
              child: CircularProgressIndicator(
            color: Colors.grey,
          )),
        ),
      );
    }

    if (authInit.hasError) {
      // 初期化中にエラーが発生した場合はエラーメッセージを表示
      return MaterialApp(
        title: F.title,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text("エラーが発生しました: ${authInit.error}"),
          ),
        ),
      );
    }

    return MaterialApp.router(
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      title: F.title,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
    );
  }
}
