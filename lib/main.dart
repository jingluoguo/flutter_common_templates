import 'package:flutter/material.dart';
import 'package:flutter_common_templates/audio_module/audio_page.dart';
import 'package:flutter_common_templates/cascade_module/cascade_page.dart';
import 'package:flutter_common_templates/chat_module/chat_page.dart';
import 'package:flutter_common_templates/click_position_dialog/test_click_position_dialog.dart';
import 'package:flutter_common_templates/constrained_module/constrained_page.dart';
import 'package:flutter_common_templates/customer_text_field/test_customer_text_field.dart';
import 'package:flutter_common_templates/isolate_module/isolate_page.dart';
import 'package:flutter_common_templates/local_auth_module/local_auth_page.dart';
import 'package:flutter_common_templates/pomodoro_module/pomodoro_page.dart';
import 'package:flutter_common_templates/screen_saver_module/screen_saver_page.dart';
import 'package:flutter_common_templates/share_module/share_page.dart';
import 'package:flutter_common_templates/socket_module/socket_page.dart';

import 'dial_module/dial_page.dart';
import 'scale_drag/test_scale_drag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Common Templates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _titleList = [
    '1. 聊天界面',
    '2. 自定义密码输入框',
    '3. 根据点击位置生成弹窗',
    '4. 长按生成六边形',
    '5. 级联',
    '6. 番茄钟',
    '7. local auth',
    '8. 屏保样式',
    '9. socket通信',
    '10. 闹钟表盘',
    '11. 分享',
    '12. 外设状态',
    '13. isolate双向通信',
    '14. 测试约束性'
  ];

  final List<Widget> _pageList = [
    const ChatPage(),
    const TestCustomerTextField(),
    TestClickPositionDialog(),
    const TestScaleDrag(),
    const CascadePage(),
    const PomodoroPage(),
    const LocalAuthPage(),
    const ScreenSaverPage(),
    const SocketPage(),
    const DialPage(),
    const SharePage(),
    const AudioPage(),
    const IsolatePage(),
    const ConstrainedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'SFPro1'
            ),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => _pageList[index])),
              child: Container(
                width: double.infinity,
                height: 100.0,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red.withOpacity(0.1), blurRadius: 10.0)
                  ],
                ),
                child: Center(
                  child: Text(
                    _titleList[index],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: (index == 1 ? 'SFPro1' : index == 3 ? 'SFPro2' : 'SFPro')
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _titleList.length,
        ));
  }
}
