import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolatePage extends StatefulWidget {
  const IsolatePage({Key? key}) : super(key: key);

  @override
  _IsolatePageState createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {

  Isolate? newIsolate;
  SendPort? newIsolateSendPort;
  SendPort? rootIsolateSendPort;

  //特别需要注意:establishConn执行环境是rootIsolate
  void establishConn() async {
    //第1步: 默认执行环境下是rootIsolate，所以创建的是一个rootIsolateReceivePort
    ReceivePort rootIsolateReceivePort = ReceivePort();
    //第2步: 获取rootIsolateSendPort
    rootIsolateSendPort = rootIsolateReceivePort.sendPort;
    //第3步: 创建一个newIsolate实例，并把rootIsolateSendPort作为参数传入到newIsolate中，为的是让newIsolate中持有rootIsolateSendPort, 这样在newIsolate中就能向rootIsolate发送消息了
    newIsolate = await Isolate.spawn(createNewIsolateContext,
        rootIsolateSendPort!); //注意createNewIsolateContext这个函数执行环境就会变为newIsolate, rootIsolateSendPort就是createNewIsolateContext回调函数的参数
    //第4步: 通过rootIsolateReceivePort接收到来自newIsolate的消息，所以可以注意到这里是await 因为是异步消息
    rootIsolateReceivePort.listen((message) {
      print("root 收到的消息：$message");
      if (message is SendPort) {
        print("newIsolateSendPort $message");
        newIsolateSendPort = message;
      }
      if (message is String && message == "close") {
        // 此时会关掉rootIsolate，会导致Dart Error: isolate terminated by Isolate.kill
        // Isolate.exit(rootIsolateSendPort);
      }
    });
  }

  //特别需要注意:createNewIsolateContext执行环境是newIsolate
  static void createNewIsolateContext(SendPort rootIsolateSendPort) async {
    // rootIsolateSendPort1 = rootIsolateSendPort;
    //第1步: 注意callback这个函数执行环境就会变为newIsolate, 所以创建的是一个newIsolateReceivePort
    ReceivePort newIsolateReceivePort = ReceivePort();
    //第2步: 获取newIsolateSendPort, 有人可能疑问这里为啥不是直接让全局newIsolateSendPort赋值，注意这里执行环境不是rootIsolate
    SendPort newIsolateSendPort = newIsolateReceivePort.sendPort;
    //第3步: 特别需要注意这里，这里是利用rootIsolateSendPort向rootIsolate发送消息，只不过发送消息是newIsolate的SendPort, 这样rootIsolate就能拿到newIsolate的SendPort
    rootIsolateSendPort.send(newIsolateSendPort);
    newIsolateReceivePort.listen((message) {
      print("new 收到的消息：$message");
      if (message is String && message == "close") {
        // 此时会关掉newIsolate，并返回值
        Isolate.exit(rootIsolateSendPort, message);
        // 等价，不过不一定能拿到rootIsolateSendPort和newIsolate
        // rootIsolateSendPort?.send(message);
        // newIsolate?.kill(priority: Isolate.immediate);
      }
    });
  }

  @override
  void initState() {
    establishConn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('isolate 双向通信'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print("send to new");
                newIsolateSendPort?.send("hello new");
              },
              child: Container(
                height: 48.0,
                width: 100.0,
                color: Colors.cyanAccent,
                child: const Center(
                  child: Text("send to new"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("send to root");
                rootIsolateSendPort?.send("hello root");
              },
              child: Container(
                height: 48.0,
                width: 100.0,
                color: Colors.cyanAccent,
                child: const Center(
                  child: Text("send to root"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("关闭");
                if (newIsolateSendPort != null) {
                  newIsolateSendPort?.send("close");
                }
              },
              child: Container(
                height: 48.0,
                width: 100.0,
                color: Colors.cyanAccent,
                child: const Center(
                  child: Text("close"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
