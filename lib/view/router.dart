import 'package:flutter/material.dart';
import 'package:flutter_template/view/screens/home.dart';
import 'package:flutter_template/view/screens/auth.dart';
import 'package:flutter_template/view_model/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
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
          child: const Scaffold(body: Home()),
        );
      },
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const Scaffold(body: Auth()),
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
