import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/model/local_data/initializer.dart';
import 'package:flutter_template/view/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseInitializer.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      title: 'flutter_template',
      debugShowCheckedModeBanner: false,
    );
  }
}
