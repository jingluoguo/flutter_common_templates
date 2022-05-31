import 'dart:math';

import 'package:flutter/material.dart';

/// guoshijun created this file at 2022/5/16 3:07 下午
///
/// 长按生成六边形

class TestScaleDrag extends StatefulWidget {
  const TestScaleDrag({Key? key}) : super(key: key);

  @override
  _TestScaleDragState createState() => _TestScaleDragState();
}

class _TestScaleDragState extends State<TestScaleDrag> {
  final GlobalKey _globalKey = GlobalKey();

  //设置起始图片高宽度大小
  double imgWidth = 200.0;
  double imgHeight = 200.0;

  double scale = 1.0;

  double diameter = 120.0;

  double half = 0.0;
  List<Offset> canPoints = [];
  List<Offset> nowPoints = [];

  @override
  void initState() {
    half = sin(pi / 3) * diameter / 2;
    nowPoints = [Offset.zero];
    generateCanPositionPoints(nowPoints);
    super.initState();
  }

  /// 生成周边点
  generateCanPositionPoints(List<Offset> nowPoints) {
    for (var item in nowPoints) {
      if (!canPoints.contains(
          Offset((-60.0 * 1.5 + item.dx) * scale, (half + item.dy) * scale))) {
        canPoints.add(
            Offset((-60.0 * 1.5 + item.dx) * scale, (half + item.dy) * scale));
      }
      if (!canPoints.contains(
          Offset((-60.0 * 1.5 + item.dx) * scale, (-half + item.dy) * scale))) {
        canPoints.add(
            Offset((-60.0 * 1.5 + item.dx) * scale, (-half + item.dy) * scale));
      }
      if (!canPoints.contains(
          Offset((0 + item.dx) * scale, (-2 * half + item.dy) * scale))) {
        canPoints
            .add(Offset((0 + item.dx) * scale, (-2 * half + item.dy) * scale));
      }
      if (!canPoints.contains(
          Offset((60.0 * 1.5 + item.dx) * scale, (-half + item.dy) * scale))) {
        canPoints.add(
            Offset((60.0 * 1.5 + item.dx) * scale, (-half + item.dy) * scale));
      }
      if (!canPoints.contains(
          Offset((60.0 * 1.5 + item.dx) * scale, (half + item.dy) * scale))) {
        canPoints.add(
            Offset((60.0 * 1.5 + item.dx) * scale, (half + item.dy) * scale));
      }
    }
    setState(() {});
  }

  /// 判断点在六边形的位置
  void checkClickPosition(Offset offset) {
    for (var item in canPoints) {
      if ((item.dx - offset.dx).abs() < (diameter / 2) ||
          (offset.dx - item.dx).abs() < (diameter / 2)) {
        if ((item.dy - offset.dy).abs() < (diameter / 2) ||
            (offset.dy - item.dy).abs() < (diameter / 2)) {
          nowPoints.add(item);
          canPoints.remove(item);
          generateCanPositionPoints(nowPoints);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleUpdate: (ScaleUpdateDetails e) {
        // print("开始缩放${e.scale}");
      },
      onLongPressStart: (LongPressStartDetails details) {
        RenderBox renderBox =
            _globalKey.currentContext!.findRenderObject() as RenderBox;
        Offset offset = renderBox.localToGlobal(Offset.zero);
        Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;
        Offset center = Offset(box.width / 2, (box.height / 2) + offset.dy);
        checkClickPosition(Offset(details.localPosition.dx - center.dx,
            details.localPosition.dy - center.dy));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("长按生成六边形"),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            key: _globalKey,
            painter: PaperPainter(
                diameter: diameter, canPoints: canPoints, nowPoints: nowPoints),
          ),
        ),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  final double diameter;
  final List<Offset> canPoints;
  final List<Offset> nowPoints;

  PaperPainter(
      {required this.diameter,
      required this.canPoints,
      required this.nowPoints});

  final Paint shapePaint = Paint()
    ..color = Colors.deepPurpleAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  void _getPositionAndDraw(Canvas canvas, List<Offset> offset) {
    for (var item in offset) {
      double radius = diameter / 2;
      List<Offset> points = [];
      for (int i = 0; i < 6; i++) {
        double perRad = 2 * pi / 6 * i;
        points.add(Offset(
            radius * cos(perRad) + item.dx, radius * sin(perRad) + item.dy));
      }
      _drawShape(canvas, points);
    }
  }

  void _drawShape(Canvas canvas, List<Offset> points) {
    Path shapePath = Path();
    shapePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      shapePath.lineTo(points[i].dx, points[i].dy);
    }
    shapePath.close();
    canvas.drawPath(shapePath, shapePaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _getPositionAndDraw(canvas, canPoints);
    shapePaint
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    _getPositionAndDraw(canvas, nowPoints);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
