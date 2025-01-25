import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_template/domain/entity/account.dart';
import 'package:flutter_template/view/ui/atoms/app_button.dart';
import 'package:flutter_template/view/ui/atoms/app_input.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:flutter_template/view/ui/atoms/responsive_button.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_template/view_model/auth.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdController = useTextEditingController();
    final passwordController = useTextEditingController();
    final focusNode1 = useFocusNode();
    final focusNode2 = useFocusNode();
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    ref.listen<AuthViewModelState>(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.errorMessage}'),
            duration: const Duration(milliseconds: 250),
            backgroundColor: Colors.red.shade900,
          ),
        );
        authViewModel.clearErrorMessage();
      }
    });

    void handlePress() async {
      SignInRequest data = SignInRequest(
        userId: userIdController.text,
        password: passwordController.text,
      );
      final result = await authViewModel.fetchSignIn(data);

      if (!context.mounted) return;

      if (result.error != null) return;

      context.go('/');
    }

    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200),
            padding: const EdgeInsets.all(16),
            child: const AppText(
              "サインイン",
              style: AppTextStyle.h1,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: AppInput(
              controller: userIdController,
              label: 'ユーザー名',
              color: Colors.pink.shade800,
              focusNode: focusNode1,
              onEditingComplete: () => focusNode2.requestFocus(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: AppInput(
              controller: passwordController,
              label: 'パスワード',
              color: Colors.pink.shade800,
              focusNode: focusNode2,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ResponsiveButton(
              label: "サインイン",
              color: Colors.pink.shade900,
              onPressed: () {
                handlePress();
              },
              isLoading: isLoading,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   child: AppButton(
          //     label: "もどる",
          //     color: Colors.pink,
          //     handlePress: () {
          //       context.go('/');
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
