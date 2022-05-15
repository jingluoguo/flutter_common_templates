import 'package:flutter/material.dart';
import 'package:flutter_common_templates/click_position_dialog/click_position_dialog.dart';

/// guoshijun created this file at 2022/5/16 12:31 上午
///
/// 测试点击位置生成dialog

class TestClickPositionDialog extends StatelessWidget {
  TestClickPositionDialog({Key? key}) : super(key: key);

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("根据点击位置生成dialog"),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                  top: 100,
                  left: 100,
                  right: 100,
                  child: GestureDetector(
                    key: _globalKey,
                    onTap: () {
                      RenderBox renderBox = _globalKey.currentContext!
                          .findRenderObject() as RenderBox;
                      Rect box =
                          renderBox.localToGlobal(Offset.zero) & renderBox.size;
                      double menuHeight =
                          MediaQuery.of(context).size.height - box.height;
                      double menuWidth =
                          MediaQuery.of(context).size.width * 2 / 3;
                      Navigator.push(
                              context,
                              ClickPositionDialogRoute(
                                  box, menuHeight, menuWidth, ["点击成功", "点击失败"]))
                          .then((value) => {
                                // print(value)
                              });
                    },
                    child: Container(
                      height: 100,
                      color: Colors.red,
                      child: const Center(child: Text("点击")),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
