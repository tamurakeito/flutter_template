import 'package:flutter/material.dart';
import 'package:flutter_template/model/local/app_initializer.dart';
import 'package:flutter_template/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'flutter_template',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
