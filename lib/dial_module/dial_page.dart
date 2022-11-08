import 'dart:async';
import 'dart:math';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialPage extends StatefulWidget {
  const DialPage({Key? key}) : super(key: key);

  @override
  _DialPageState createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {

  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('表盘'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 35, 36, 38),
        child: Center(
          child: CustomPaint(
            size: Size(width, width),
            painter: DialPainter(),
          ),
        ),
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  Paint _initPainter() {
    return Paint()
      ..isAntiAlias = true
      ..color = Colors.white;
  }

  late final Paint _paint = _initPainter();

  // 画布宽度
  late double width;

  // 画布高度
  late double height;

  // 表盘半径
  late double radius;

  // 比例单位长度
  late double unit;

  void initSize(Size size) {
    width = size.width;
    height = size.height;
    radius = min(width, height) / 2;
    unit = radius / 15;
  }

  void drawGradientLinearCircle(Canvas canvas){
    var gradient = ui.Gradient.linear(
        Offset(width/2, height/2 - radius,),
        Offset(width/2, height/2 + radius),
        [const Color(0xFFF9F9F9), const Color(0xFF666666)]);

    _paint.shader = gradient;
    _paint.color = Colors.white;
    canvas.drawCircle(Offset(width/2, height/2), radius, _paint);
  }

  void draGradientRadialCircle(Canvas canvas){
    var radialGradient = ui.Gradient.radial(Offset(width/2, height/2), radius, [
      const Color.fromARGB(216, 246, 248, 249),
      const Color.fromARGB(216, 229, 235, 238),
      const Color.fromARGB(216,205, 212, 217),
      const Color.fromARGB(216,245, 247, 249),
    ], [0, 0.92, 0.93, 1.0]);

    _paint.shader = radialGradient;
    canvas.drawCircle(Offset(width/2, height/2), radius - 0.3 * unit, _paint);
  }

  void drawText(Canvas canvas, Offset position, String text){
    var textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, height: 1.0)
      ),
      textAlign: TextAlign.end,
      textDirection: TextDirection.rtl,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 1
    )..layout();

    textPainter.paint(canvas, Offset(position.dx-textPainter.width/2, position.dy - textPainter.height/2));
  }

  void drawTick(Canvas canvas) {
    double dialCanvasRadius = radius - 0.8 * unit;
    canvas.save();
    canvas.translate(width/2, height/2);

    var y = 0.0;
    var x1 = 0.0;
    var x2 = 0.0;

    _paint.shader = null;
    _paint.color = const Color(0xFF929394);

    for(int i = 0; i < 60; i++){
      x1 = dialCanvasRadius - (i % 5 == 0 ? 0.85 * unit : 1 * unit);
      x2 = dialCanvasRadius - (i % 5 == 0 ? 2 * unit : 1.67 * unit);
      _paint.strokeWidth = i % 5 == 0 ? 0.38 * unit : 0.2 * unit;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), _paint);
      canvas.rotate(2*pi/60);
    }
    canvas.restore();
  }

  void drawTickValue(Canvas canvas){
    double offset = 3 * unit;
    double dialCanvasRadius = radius - 0.8 * unit - offset;
    drawText(canvas, Offset(width/2 + dialCanvasRadius, height/2), '3');
    drawText(canvas, Offset(width/2, height/2 + dialCanvasRadius), '6');
    drawText(canvas, Offset(width/2 - dialCanvasRadius, height/2), '9');
    drawText(canvas, Offset(width/2, height/2 - dialCanvasRadius), '12');
  }

  void drawCenterPoint(Canvas canvas){
    var radialGradient =
    ui.Gradient.radial(Offset(width / 2, height / 2), radius, [
      const Color.fromARGB(255, 200, 200, 200),
      const Color.fromARGB(255, 190, 190, 190),
      const Color.fromARGB(255, 130, 130, 130),
    ], [0, 0.9, 1.0]);

    /// 底部背景
    _paint
      ..shader = radialGradient
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(width/2, height/2), 2 * unit, _paint);


    /// 顶部圆点
    _paint
      ..shader = null
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF121314);
    canvas.drawCircle(Offset(width/2, height/2), 0.8 * unit, _paint);
  }

  // 绘制时针
  void drawHourPin(Canvas canvas, DateTime date){
    // 时针高度一半
    double hourHalfHeight = 0.4 * unit;
    // 时针矩形长度
    double hourRectRight = 7.4 * unit - hourHalfHeight;

    Path hourPath = Path();
    hourPath.moveTo(- hourHalfHeight, - hourHalfHeight);
    hourPath.lineTo(hourRectRight, - hourHalfHeight);
    hourPath.quadraticBezierTo(hourRectRight, -2*hourHalfHeight, hourRectRight+hourHalfHeight, -2*hourHalfHeight);
    hourPath.lineTo(1.3*hourRectRight, 0);
    hourPath.lineTo(hourRectRight+hourHalfHeight, 2*hourHalfHeight);
    hourPath.quadraticBezierTo(hourRectRight, 2*hourHalfHeight, hourRectRight, hourHalfHeight);
    hourPath.lineTo(-hourHalfHeight, hourHalfHeight);
    hourPath.close();

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.hour - 3 + date.minute/60 + date.second/60/60)*5);
    ///绘制
    _paint.color = const Color(0xFF232425);
    canvas.drawPath(hourPath, _paint);
    canvas.restore();
  }
  
  // 绘制分针
  void drawMinutePin(Canvas canvas, DateTime date){

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.minute -15 + date.second/60));

    var rect = RRect.fromLTRBR(-1.33*unit, -0.4*unit, 11*unit, 0.4*unit, Radius.circular(0.4*unit));
    _paint.color = const Color(0xFF333435);
    canvas.drawRRect(rect, _paint);

    canvas.restore();
  }

  // 绘制秒针
  void drawSecondPin(Canvas canvas, DateTime date){
    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.second -15));

    Path secondPath = Path();
    secondPath.moveTo(-2*unit, -0.2*unit);
    secondPath.lineTo(12.5*unit, 0);
    secondPath.lineTo(-2*unit, 0.2*unit);

    _paint.color = Colors.red;
    canvas.drawPath(secondPath, _paint);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    initSize(size);
    // 绘制一个线性渐变的圆
    drawGradientLinearCircle(canvas);
    
    // 绘制一层径向渐变的圆
    draGradientRadialCircle(canvas);

    // 绘制刻度线
    drawTick(canvas);

    // 绘制刻度值
    drawTickValue(canvas);

    // 绘制中心点
    drawCenterPoint(canvas);

    var date = DateTime.now().toLocal();
    print('当前时间:$date   ${DateTime.now()}');

    // 绘制时针
    drawHourPin(canvas, date);

    // 绘制分针
    drawMinutePin(canvas, date);

    // 绘制秒针
    drawSecondPin(canvas, date);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
