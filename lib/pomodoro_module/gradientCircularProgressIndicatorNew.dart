/// guoshijun created this file at 2022/4/22 3:14 下午
///
/// 番茄钟倒计时

import 'dart:core';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import '../util/util.dart';

class GradientCircularProgressIndicatorNew extends StatefulWidget {
  final Color backgroundColor;
  final Color? frondColor;
  final double strokeWidth;
  final double radius;
  final String desc1;
  final TimeCircle tag;
  final bool visible;
  final ValueChanged? onClickDelete;
  final VoidCallback? whenCompleted;

  const GradientCircularProgressIndicatorNew(
      {Key? key,
      this.backgroundColor = const Color.fromARGB(0xff, 223, 223, 223),
      this.radius = double.infinity,
      this.frondColor,
      this.strokeWidth = 16,
      this.desc1 = "测试",
      this.onClickDelete,
      this.visible = true,
      required this.tag,
      this.whenCompleted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      GradientCircularProgressIndicatorState();
}

class GradientCircularProgressIndicatorState
    extends State<GradientCircularProgressIndicatorNew>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant GradientCircularProgressIndicatorNew oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.visible) {
        return Container(
          height: widget.radius * 1.32,
          width: widget.radius,
          decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6.0)),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Obx(()=>CustomPaint(
                    painter: ProgressPainter(
                        froundColor: widget.frondColor ??
                            ((widget.tag.nowTime.value <= 30)
                                ? const Color.fromARGB(0xff, 252, 130, 10)
                                : const Color.fromARGB(0xff, 64, 94, 172)),
                        backgroundColor: widget.backgroundColor,
                        progress:
                        (widget.tag.nowTime.value / widget.tag.allTime.value) * 100,
                        strokeWidth: widget.strokeWidth),
                    size: Size.fromRadius(widget.radius / 2),
                  ))),
              Positioned(
                  left: 0,
                  right: 0,
                  top: widget.radius / 2 - 10,
                  child: Obx(()=>Center(
                      child: Visibility(
                        visible: widget.tag.visible.value,
                        child: Text(
                          CommonUtil.formatTimeBySecond(widget.tag.nowTime.value.ceil()),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )))),
              Positioned(
                child: Center(
                    child: Text(widget.desc1,
                        style: const TextStyle(fontSize: 14))),
                left: 0,
                right: 0,
                bottom: 26,
              ),
              Positioned(
                child: Center(
                    child: Text(
                        CommonUtil.formatTimeBySecond(widget.tag.allTime.value))),
                left: 0,
                right: 0,
                bottom: 8,
              ),
              Positioned(
                child: IconButton(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(3.0),
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      widget.onClickDelete?.call(widget.tag.id);
                    }),
                right: 0,
                top: 0,
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: widget.radius * 1.32,
        width: widget.radius,
        child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.transparent)),
      );
    });
  }
}

class ProgressPainter extends CustomPainter {
  Color? backgroundColor;
  Color? froundColor;
  double? strokeWidth;
  double? progress; // [0-100]

  late Paint backgroundPaint;
  late Paint froundPaint;

  ProgressPainter(
      {this.froundColor,
      this.strokeWidth,
      this.progress,
      this.backgroundColor}) {
    backgroundPaint = Paint()
      ..color = backgroundColor!
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    froundPaint = Paint()
      ..color = froundColor!
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (!(0 <= progress! && progress! <= 100)) {
      progress = 0;
    }
  }

  double get angle => -pi / 50 * progress!;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width, size.height) * 0.8 / 2;
    double padding = min(size.width, size.height) * 0.2 / 2;

    double centerX = size.width / 2;
    double centerY = padding + radius;

    canvas.drawArc(
        Rect.fromLTRB(centerX - radius, centerY - radius, centerX + radius,
            centerY + radius),
        -pi / 2,
        2 * pi,
        false,
        backgroundPaint);

    canvas.drawArc(
        Rect.fromLTRB(centerX - radius, centerY - radius, centerX + radius,
            centerY + radius),
        -pi / 2,
        angle,
        false,
        froundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
