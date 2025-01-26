import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_template/model/local_data/initializer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseInitializer.initialize();
  runApp(const ProviderScope(child: App()));
}
