import 'package:flutter/material.dart';

/// guoshijun created this file at 2022/5/19 17:14
///
/// 级联页面

class CascadePage extends StatefulWidget {
  const CascadePage({Key? key}) : super(key: key);

  @override
  _CascadePageState createState() => _CascadePageState();
}

class _CascadePageState extends State<CascadePage> {
  List<String> leftList = ["附近热门", "行政区域", "车站机场", "商圈", "景点", "高校"];

  int leftSelect = 0;

  List<String> rightList = ["临沂中心万达店", "岚山恒大华府点", "车站机场", "商圈", "景点", "高校"];

  String rightSelect = '';

  /// 当选中时显示选中符号
  Widget _checkStatus(status) {
    if (status) {
      return const Icon(
        Icons.chevron_right,
        size: 32.0,
      );
    }
    return const Expanded(child: Text(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("级联"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 600.0,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: leftList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => setState(() {
                              leftSelect = index;
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              color: leftSelect == index
                                  ? Colors.white
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Text(
                                leftList[index],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: leftSelect == index
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          );
                        }),
                  )),
              Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 600.0,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: rightList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 60.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      rightSelect = rightList[index];
                                    }),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Text(
                                            rightList[index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: rightSelect ==
                                                        rightList[index]
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        _checkStatus(
                                            rightSelect == rightList[index]),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1.0,
                                    color: Colors.grey.withOpacity(0.2),
                                  )
                                ],
                              ));
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
