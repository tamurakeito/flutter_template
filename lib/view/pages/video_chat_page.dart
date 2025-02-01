import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = Provider<WebSocketChannel>((ref) {
  const url = 'ws://192.168.0.112:8081/ws';
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
    final RTCVideoRenderer localVideoRenderer =
        useMemoized(() => RTCVideoRenderer());

    final localSDP = useState<String>(""); // SDP を保存
    final peerConnectionRef = useRef<RTCPeerConnection?>(null);

    useEffect(() {
      localVideoRenderer.initialize();
      startLocalStream(localVideoRenderer, peerConnectionRef, localSDP); // 修正済み

      return () {
        if (peerConnectionRef.value != null) {
          peerConnectionRef.value!.close();
        }
        localVideoRenderer.dispose();
      };
    }, []);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Video Chat",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Received Message: $message',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: RTCVideoView(localVideoRenderer, mirror: true),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'メッセージを入力する',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  webSocket.sink
                      .add(jsonEncode({'message': messageController.text}));
                },
                child: const Text('送信する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ローカルストリームの取得と SDP 生成
Future<void> startLocalStream(
  RTCVideoRenderer localVideoRenderer,
  ObjectRef<RTCPeerConnection?> peerConnectionRef,
  ValueNotifier<String> localSDP,
) async {
  try {
    // STUN サーバーの設定
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    // PeerConnection の作成
    final RTCPeerConnection peerConnection =
        await createPeerConnection(configuration);
    peerConnectionRef.value = peerConnection;

    // フロントカメラ（内カメ）を指定
    final Map<String, dynamic> mediaConstraints = {
      'video': {
        'facingMode': 'user', // フロントカメラを指定
      },
      'audio': true,
    };

    // ローカルストリームの取得
    final MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    // RTCVideoRenderer にストリームを設定
    localVideoRenderer.srcObject = stream;

    // PeerConnection にストリームを追加
    for (var track in stream.getTracks()) {
      peerConnection.addTrack(track, stream);
    }

    // SDP を生成
    final RTCSessionDescription offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    // SDP を保存
    localSDP.value = offer.sdp ?? "";
    print("Generated SDP: ${offer.sdp}");
  } catch (error) {
    print("Error accessing media devices: $error");
  }
}
