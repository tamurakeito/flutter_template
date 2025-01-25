import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/errors/error.dart';
import 'package:flutter_template/view/ui/atoms/app_button.dart';
import 'package:flutter_template/view_model/auth.dart';
import 'package:flutter_template/view_model/example.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helloWorldViewModel = ref.read(helloWorldViewModelProvider.notifier);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    ref.listen<HelloWorldViewModelState>(helloWorldViewModelProvider,
        (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != "ネットワーク接続がありません" &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.errorMessage}'),
            duration: const Duration(milliseconds: 250),
            backgroundColor: Colors.red.shade900,
          ),
        );
        helloWorldViewModel.clearErrorMessage();
      }
    });

    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "Hello, World!",
                style: AppTextStyle.h1,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "http",
                style: AppTextStyle.h2,
              ),
            ),
            HttpButton(
              viewModel: helloWorldViewModel,
              id: 1,
            ),
            HttpButton(
              viewModel: helloWorldViewModel,
              id: 2,
            ),
            HttpButton(
              viewModel: helloWorldViewModel,
              id: 3,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "local data",
                style: AppTextStyle.h2,
              ),
            ),
            LocalDataButton(
              viewModel: helloWorldViewModel,
              id: 1,
            ),
            LocalDataButton(
              viewModel: helloWorldViewModel,
              id: 2,
            ),
            LocalDataButton(
              viewModel: helloWorldViewModel,
              id: 3,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "routing",
                style: AppTextStyle.h2,
              ),
            ),
            AppButton(
              label: "auth",
              color: Colors.pink,
              handlePress: () {
                context.push('/auth');
              },
            ),
            AppButton(
              label: "ログアウト",
              color: Colors.pink,
              handlePress: () {
                authViewModel.clearUser();
                context.push('/auth');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HttpButton extends HookWidget {
  final HelloWorldViewModel viewModel;
  final int id;
  const HttpButton({
    super.key,
    required this.viewModel,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);

    void handlePress() async {
      isLoading.value = true;
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        final result = await viewModel.fetchHttpHelloWorldDetail(id);

        if (!context.mounted) return;

        if (result.error != null) {
          // ネットワーク非接続時にローカルデータを参照
          if (result.error == HttpError.networkUnavailable) {
            final result = await viewModel.fetchLocalHelloWorldDetail(id);
            if (!context.mounted) return;
            if (result.error != null) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.data!.hello.name),
                duration: const Duration(milliseconds: 250),
                backgroundColor: Colors.blue.shade900,
              ),
            );
          }
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.data!.hello.name),
            duration: const Duration(milliseconds: 250),
            backgroundColor: Colors.green.shade900,
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return AppButton(
      label: "tap! :$id",
      color: Colors.orange,
      handlePress: handlePress,
      isLoading: isLoading,
    );
  }
}

class LocalDataButton extends HookWidget {
  final HelloWorldViewModel viewModel;
  final int id;
  const LocalDataButton({
    super.key,
    required this.viewModel,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);

    void handlePress() async {
      isLoading.value = true;
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        final result = await viewModel.fetchLocalHelloWorldDetail(id);

        if (!context.mounted) return;

        if (result.error != null) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.data!.hello.name),
            duration: const Duration(milliseconds: 250),
            backgroundColor: Colors.blue.shade900,
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return AppButton(
      label: "tap! :$id",
      color: Colors.indigo,
      handlePress: handlePress,
      isLoading: isLoading,
    );
  }
}
