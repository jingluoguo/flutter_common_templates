import 'dart:io';

import 'package:flutter/material.dart';

/// 局域网内通信
class SocketPage extends StatefulWidget {
  const SocketPage({Key? key}) : super(key: key);

  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {

  /// 服务端变量
  HttpServer? server;
  WebSocket? serviceSocket;
  var serviceReceivedMsg = '暂无消息';

  /// 服务端操作
  void serviceBinding(String ip, int port) async {
    if(server != null) return;
    server = await HttpServer.bind(ip, port);
    print('-------------服务器绑定成功-------------');

    server?.listen((HttpRequest req) async {
      await WebSocketTransformer.upgrade(req).then((webSocket) {
        webSocket.listen(handleMsg);
        serviceSocket = webSocket;
      });
    });
  }

  void handleMsg(dynamic msg){
    print('收到客户端消息:$msg');
    setState(() {
      serviceReceivedMsg = msg;
    });
  }

  void serviceSendMsg(String msg) {
    if(msg.isEmpty || serviceSocket == null){
      return;
    }
    serviceSocket?.add(msg);
  }

  void servicesSendMsgBytes(List<int> bytes) {
    if(bytes.isEmpty || serviceSocket == null){
      return;
    }
    serviceSocket?.addUtf8Text(bytes);
  }

  void serverSendVideoFrameSteam(var dataBytes) {
    if(dataBytes == null || serviceSocket == null) {
      return;
    }
    var msg = Stream.value(dataBytes);

    serviceSocket?.addStream(msg).then((value) => null);
  }

  /// 客户端变量
  WebSocket? clientSocket;
  var clientReceivedMsg = '暂无消息';

  /// 客户端操作
  void clientConnect(String ip) async {
    clientSocket = await WebSocket.connect(ip);
    print('-------------客户端连接成功-------------');
    clientSocket?.listen(clientReceived);
    clientSocket?.add(DateTime.now().toString());
  }
  void clientReceived(msg) {
    print('收到服务端消息:$msg');
    setState(() {
      clientReceivedMsg = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket通信'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()=>serviceBinding('192.168.4.72', 8090),
              child: Container(
                height: 48.0,
                width: 100.0,
                color: Colors.cyanAccent,
                child: const Center(
                  child: Text("建立连接"),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: ()=>clientConnect('ws://192.168.4.72:8090/ws'),
              child: Container(
                height: 48.0,
                width: 100.0,
                color: Colors.cyanAccent,
                child: const Center(
                  child: Text("发送消息"),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text("服务端收到消息:$serviceReceivedMsg"),
            const SizedBox(height: 10.0),
            Text("客户端收到消息:$clientReceivedMsg"),
          ],
        ),
      ),
    );
  }
}
