import 'package:flutter/material.dart';
import 'package:flutter_template/model/local/injecter/injecter.dart';
import 'package:flutter_template/model/local/presentation/handler/example_handler.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final helloHandler = Injector.injectHelloHandler();

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text("Hello, World!"),
              HelloworldButton(handler: helloHandler, id: 1),
              HelloworldButton(handler: helloHandler, id: 2),
              HelloworldButton(handler: helloHandler, id: 3),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class HelloworldButton extends StatelessWidget {
  final HelloworldHandler handler;
  final int id;
  const HelloworldButton({super.key, required this.handler, required this.id});

  @override
  Widget build(BuildContext context) {
    void handlePress() async {
      try {
        // Handler の関数を呼び出す
        final result = await handler.helloWorldDetail(id);
        if (result.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${result.error}'),
              duration: const Duration(milliseconds: 250),
            ),
          );
        }
        if (result.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: data is null'),
              duration: Duration(milliseconds: 250),
            ),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.data!.hello.name),
            duration: const Duration(milliseconds: 250),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(milliseconds: 250),
          ),
        );
      }
    }

    return TextButton(
      onPressed: handlePress,
      child: Text(
        "tap! :$id",
        style: TextStyle(
          color: Colors.blue.shade900,
        ),
      ),
    );
  }
}
