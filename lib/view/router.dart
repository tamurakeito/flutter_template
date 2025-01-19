import 'package:flutter/material.dart';
import 'package:flutter_template/view/screens/home.dart';
import 'package:flutter_template/view/screens/sign_in.dart';
import 'package:flutter_template/view/screens/sign_up.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  // アプリが起動した時
  initialLocation: '/',
  // パスと画面の組み合わせ
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const Scaffold(body: Home()),
        );
      },
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const Scaffold(body: SignIn()),
        );
      },
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const Scaffold(body: SignUp()),
        );
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
