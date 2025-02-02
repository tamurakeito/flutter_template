import 'package:flutter/material.dart';
import 'package:flutter_template/view/pages/home_page.dart';
import 'package:flutter_template/view/pages/auth_page.dart';
import 'package:flutter_template/view_model/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);

    final authInit = container.read(authInitializerProvider);
    if (authInit.isLoading) {
      return null; // 初期化中はリダイレクトしない
    }

    final user = container.read(authViewModelProvider).user;
    final currentPath = state.uri.toString();

    if (user == null && currentPath == '/') {
      return '/auth';
    }

    if (user != null && currentPath == '/auth') {
      container.read(authViewModelProvider.notifier).clearUser();
      return null;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const AuthPage(),
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
