/// guoshijun created this file at 2022/5/20 15:48
///
/// 工具类

class CommonUtil {
  /// 描述：格式化时间
  /// 目前使用场景：格式化番茄钟部分展示时间
  /// 局限性：仅支持00:00:00、00:00格式
  static String formatTimeBySecond(int second) {
    Duration duration = Duration(seconds: second);
    var hours = duration.inHours % 24;
    var minutes = duration.inMinutes % 60;
    var seconds = duration.inSeconds % 60;
    if (duration.inHours == 0) {
      return "${minutes >= 10 ? minutes : "0$minutes"}:${seconds >= 10 ? seconds : "0$seconds"}";
    } else {
      return "${hours >= 10 ? hours : "0$hours"}:${minutes >= 10 ? minutes : "0$minutes"}:${seconds >= 10 ? seconds : "0$seconds"}";
    }
  }
}
