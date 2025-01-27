import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_template/types/account.dart';
import 'package:flutter_template/view/services/snackbar_service.dart';
import 'package:flutter_template/view/ui/atoms/app_input.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:flutter_template/view/ui/atoms/clickable_text.dart';
import 'package:flutter_template/view/ui/atoms/responsive_button.dart';
import 'package:flutter_template/view/ui/molecules/password_input.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_template/view_model/auth.dart';

class Auth extends HookConsumerWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdController = useTextEditingController();
    final passwordController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final familyNameController = useTextEditingController();
    final focusNode1 = useFocusNode();
    final focusNode2 = useFocusNode();
    final focusNode3 = useFocusNode();
    final focusNode4 = useFocusNode();
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final isLoading = ref.watch(authViewModelProvider).isLoading;
    final isSignUpView = useState(false);
    final isDetailRegisterView = useState(false);

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

    void handleSignIn() async {
      SignInRequest data = SignInRequest(
        userId: userIdController.text,
        password: passwordController.text,
      );
      final result = await authViewModel.fetchSignIn(data);

      if (!context.mounted) return;

      if (result.error != null) return;

      context.go('/');

      await Future.delayed(const Duration(milliseconds: 500));
      SnackbarService.showSnackBar(
        'ログインしました',
        color: Colors.pink.shade900,
        duration: const Duration(milliseconds: 1000),
      );
    }

    void handleSignUp() async {
      SignUpRequest data = SignUpRequest(
        userId: userIdController.text,
        password: passwordController.text,
        name: '${familyNameController.text} ${firstNameController.text}',
      );
      final result = await authViewModel.fetchSignUp(data);

      if (!context.mounted) return;

      if (result.error != null) return;

      context.go('/');

      await Future.delayed(const Duration(milliseconds: 500));
      SnackbarService.showSnackBar(
        'アカウントが登録されました',
        color: Colors.pink.shade900,
        duration: const Duration(milliseconds: 1000),
      );
    }

    void handleSignOut() {
      isSignUpView.value = !isSignUpView.value;
      isDetailRegisterView.value = false;
    }

    return Center(
      child: Column(
        children: [
          !isSignUpView.value
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 200),
                      padding: const EdgeInsets.all(16),
                      child: const AppText(
                        "ログイン",
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
                      child: PasswordInput(
                        controller: passwordController,
                        label: 'パスワード',
                        color: Colors.pink.shade800,
                        focusNode: focusNode2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: ResponsiveButton(
                        label: "ログイン",
                        color: Colors.pink.shade900,
                        onPressed: () {
                          handleSignIn();
                        },
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                )
              : !isDetailRegisterView.value
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          padding: const EdgeInsets.all(16),
                          child: const AppText(
                            "新規アカウント登録",
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
                          child: PasswordInput(
                            controller: passwordController,
                            label: 'パスワード',
                            color: Colors.pink.shade800,
                            focusNode: focusNode2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: ResponsiveButton(
                            label: "次へ",
                            color: Colors.pink.shade900,
                            onPressed: () {
                              isDetailRegisterView.value = true;
                            },
                            isLoading: isLoading,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          padding: const EdgeInsets.all(16),
                          child: const AppText(
                            "以下の情報を登録してください",
                            style: AppTextStyle.h1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: AppInput(
                            controller: familyNameController,
                            label: '姓',
                            color: Colors.pink.shade800,
                            focusNode: focusNode3,
                            onEditingComplete: () => focusNode3.requestFocus(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: AppInput(
                            controller: firstNameController,
                            label: '名',
                            color: Colors.pink.shade800,
                            focusNode: focusNode4,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: ResponsiveButton(
                            label: "新規アカウント登録",
                            color: Colors.pink.shade900,
                            onPressed: () {
                              handleSignUp();
                            },
                            isLoading: isLoading,
                          ),
                        ),
                      ],
                    ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            child: ClickableText(
              !isSignUpView.value ? "新規アカウント登録" : "ログイン",
              onTap: () => handleSignOut(),
              style: TextStyle(color: Colors.pink.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
