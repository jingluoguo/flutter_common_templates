import 'package:flutter/material.dart';

import 'widget/matrix_effect_page.dart';

class ScreenSaverPage extends StatefulWidget {
  const ScreenSaverPage({Key? key}) : super(key: key);

  @override
  _ScreenSaverPageState createState() => _ScreenSaverPageState();
}

class _ScreenSaverPageState extends State<ScreenSaverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('屏保列表'),
      ),
      body: Column(
        children: const [
          Text('矩阵效应'),
          Padding(padding: EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: MatrixEffect(height: 200),
          ),)
        ],
      ),
    );
  }
}
