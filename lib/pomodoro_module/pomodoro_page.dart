import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model.dart';
import '../util/util.dart';
import 'gradientCircularProgressIndicatorNew.dart';

/// guoshijun created this file at 2022/5/20 15:35
///
/// 番茄钟

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late List<TimeCircle> allTimeCircle = [];

  final timers = <Duration>[
    const Duration(seconds: 5),
    const Duration(minutes: 1),
    const Duration(minutes: 3),
    const Duration(minutes: 5),
    const Duration(minutes: 10),
    const Duration(minutes: 15),
    const Duration(minutes: 20),
    const Duration(minutes: 60),
    const Duration(minutes: 90),
    const Duration(minutes: 120),
  ];

  void onClickTimerButton(Duration dura) {
    String? timeStr = CommonUtil.formatTimeBySecond(dura.inSeconds);
    var timeCircle = TimeCircle(
        timeStr.obs, dura.inSeconds.toDouble().obs, dura.inSeconds.obs);
    setState(() {
      allTimeCircle.add(timeCircle);
      allTimeCircle.sort((a, b) => a.nowTime.value.compareTo(b.nowTime.value));
    });
  }

  /// 获取倒计时
  List<GradientCircularProgressIndicatorNew> getAllProgress() {
    List<GradientCircularProgressIndicatorNew> children = [];
    for (var index = 0; index < allTimeCircle.length; index++) {
      children.add(GradientCircularProgressIndicatorNew(
        tag: allTimeCircle[index],
        whenCompleted: () async {},
        onClickDelete: (id) {
          setState(() {
            TimeCircle timeCircle = allTimeCircle.removeAt(index);
            timeCircle.destroy();
          });
        },
        onClickPause: (id) {
          allTimeCircle.firstWhere((value) {
            if (value.id == id) {
              value.changeTimerStatus();
              return true;
            }
            return false;
          });
        },
        radius: (MediaQuery.of(context).size.width - 80 - 6) / 2,
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("番茄钟"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            allTimeCircle.isNotEmpty
                ? Wrap(
                    spacing: 0,
                    runSpacing: 10,
                    runAlignment: WrapAlignment.center,
                    children: getAllProgress(),
                  )
                : const SizedBox(),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              runAlignment: WrapAlignment.center,
              children: timers
                  .map((e) => SizedBox(
                        width: (MediaQuery.of(context).size.width - 80) / 3,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            onClickTimerButton(e);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 3, 50)),
                          ),
                          child:
                              Text(CommonUtil.formatTimeBySecond(e.inSeconds)),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
