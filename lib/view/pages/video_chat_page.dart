import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_template/view/ui/atoms/app_input.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:flutter_template/view/ui/atoms/responsive_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = Provider<WebSocketChannel>((ref) {
  const url = 'ws://localhost:8081/ws';
  return WebSocketChannel.connect(Uri.parse(url));
});

final messageProvider = StateProvider<String>((ref) => '');

class VideoChatPage extends HookConsumerWidget {
  const VideoChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocket = ref.watch(webSocketProvider);
    final message = ref.watch(messageProvider);
    final messageController = useTextEditingController();

    useEffect(() {
      final subscription = webSocket.stream.listen((data) {
        print('recieve: ${data.toString()}');
        ref.read(messageProvider.notifier).state = data.toString();
      });

      return subscription.cancel;
    }, [webSocket]);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: AppText(
                "video chat",
                style: AppTextStyle.h2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppText(
                'Recieved Message: $message',
                style: AppTextStyle.md,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppInput(
                controller: messageController,
                label: 'メッセージを入力する',
                color: Colors.purple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ResponsiveButton(
                label: '送信する',
                color: Colors.purple,
                onPressed: () {
                  webSocket.sink
                      .add(jsonEncode({'message': messageController.text}));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
