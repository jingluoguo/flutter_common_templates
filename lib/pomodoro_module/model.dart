import 'dart:async';

import 'package:get/get.dart';

/// guoshijun created this file at 2022/5/20 15:52
///
/// 存储番茄钟的model

class TimeCircle {
  late int id;
  RxString tag;
  RxDouble nowTime;
  RxInt allTime;
  RxBool visible = true.obs;
  late Timer _timer;
  RxBool start = true.obs;

  /// 时间函数
  startTime(){
    int durationTime = 1000;
    if(allTime.value < 180){
      durationTime = 10;
    }
    var oneSec = Duration(milliseconds: durationTime);
    _timer = Timer.periodic(oneSec, (timer) {
      if ((nowTime.value - (durationTime / 1000)) < 0) {
        nowTime.value = 0.0;
        destroy();
      } else {
        nowTime.value = nowTime.value - (durationTime / 1000);
      }
    });
  }

  /// 构造函数时开启倒计时
  TimeCircle(this.tag, this.nowTime, this.allTime) {
    id = DateTime.now().second;
    startTime();
  }

  /// 倒计时完成后开始文本闪烁
  complete() {
    const oneCompleteSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(oneCompleteSec, (timer) {
      visible.value = !visible.value;
    });
  }

  destroy() async {
    _timer.cancel();
  }

  /// 暂停或开启时间
  changeTimerStatus(){
    if(_timer.isActive){
      start.value = false;
      _timer.cancel();
    } else {
      start.value = true;
      startTime();
    }
  }
}
