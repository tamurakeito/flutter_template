import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = Provider<WebSocketChannel>((ref) {
  const url = 'ws://192.168.0.112:8081/ws'; // WebSocket サーバーのアドレス
  return WebSocketChannel.connect(Uri.parse(url));
});

final messageProvider = StateProvider<String>((ref) => '');

class VideoChatPage extends HookConsumerWidget {
  const VideoChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocket = ref.watch(webSocketProvider);
    // final message = ref.watch(messageProvider);
    // final messageController = useTextEditingController();
    final RTCVideoRenderer localVideoRenderer =
        useMemoized(() => RTCVideoRenderer());
    final RTCVideoRenderer remoteVideoRenderer =
        useMemoized(() => RTCVideoRenderer());

    final localSDP = useState<String>(""); // SDP を保存
    final peerConnectionRef = useRef<RTCPeerConnection?>(null);

    final String clientId = const Uuid().v4(); // UUID を生成

    useEffect(() {
      localVideoRenderer.initialize();
      remoteVideoRenderer.initialize();
      startLocalStream(
        localVideoRenderer,
        peerConnectionRef,
        localSDP,
        webSocket,
      );

      final subscription = webSocket.stream.listen((data) {
        final message = jsonDecode(data);
        handleSignalingMessage(
          ref,
          message,
          peerConnectionRef,
          remoteVideoRenderer,
          clientId,
        );
      });

      return () {
        if (peerConnectionRef.value != null) {
          peerConnectionRef.value!.close();
        }
        localVideoRenderer.dispose();
        remoteVideoRenderer.dispose();
        subscription.cancel();
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
            Expanded(
              child: RTCVideoView(localVideoRenderer, mirror: true),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Remote Video"),
            ),
            Expanded(
              child: RTCVideoView(remoteVideoRenderer),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  if (peerConnectionRef.value != null) {
                    RTCSessionDescription? localDesc =
                        await peerConnectionRef.value!.getLocalDescription();
                    if (localDesc != null) {
                      webSocket.sink.add(jsonEncode({
                        'type': 'offer',
                        'sdp': localDesc.sdp,
                        'clientId': clientId, // ✅ React と統一
                      }));

                      print("Sent SDP: ${localDesc.sdp}");
                    }
                  }
                },
                child: const Text('SDP を送信'),
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
  WebSocketChannel webSocket,
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

    // ICE Candidate を WebSocket で送信
    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        webSocket.sink.add(jsonEncode({
          'type': 'candidate',
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        }));
      }
    };

    // ローカルストリームの取得
    final MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'video': {
        'facingMode': 'user',
      },
      'audio': true,
    });

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

/// シグナリングメッセージを処理
void handleSignalingMessage(
  WidgetRef ref,
  Map<String, dynamic> message,
  ObjectRef<RTCPeerConnection?> peerConnectionRef,
  RTCVideoRenderer remoteVideoRenderer,
  String clientId,
) async {
  if (peerConnectionRef.value == null) return;

  if (message['type'] == 'offer') {
    print("Received SDP Offer");

    // リモート SDP を設定
    await peerConnectionRef.value!.setRemoteDescription(
      RTCSessionDescription(message['sdp'], 'offer'),
    );

    // アンサーを生成
    final RTCSessionDescription answer =
        await peerConnectionRef.value!.createAnswer();
    await peerConnectionRef.value!.setLocalDescription(answer);

    // SDP を WebSocket で送信
    peerConnectionRef.value!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        ref.read(webSocketProvider).sink.add(jsonEncode({
              'type': 'candidate',
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
              'clientId': clientId, // ✅ React と統一
            }));
      }
    };

    ref.read(webSocketProvider).sink.add(jsonEncode({
          'type': 'answer',
          'sdp': answer.sdp,
        }));
  } else if (message['type'] == 'answer') {
    print("Received SDP Answer");

    // リモート SDP を設定
    await peerConnectionRef.value!.setRemoteDescription(
      RTCSessionDescription(message['sdp'], 'answer'),
    );
  } else if (message['type'] == 'candidate') {
    print("Received ICE Candidate");

    // ICE Candidate を追加
    RTCIceCandidate candidate = RTCIceCandidate(
      message['candidate'],
      message['sdpMid'],
      message['sdpMLineIndex'],
    );
    await peerConnectionRef.value!.addCandidate(candidate);
  }
}
