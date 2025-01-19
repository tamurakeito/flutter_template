import 'package:flutter/material.dart';
import 'package:flutter_template/view/ui/atoms/app_button.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUp extends HookConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
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
            child: AppButton(
              label: "もどる",
              color: Colors.deepPurple,
              handlePress: () {
                context.pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
