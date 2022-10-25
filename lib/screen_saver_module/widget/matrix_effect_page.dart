import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

enum Scale {
  zoomIn,
  normal,
  zoomOut,
}

class MatrixEffect extends StatefulWidget {
  /// 数据集
  final List<String>? characters;

  /// 单次生成词组数量
  final int initCount;

  /// 生成速度(单位：毫秒)
  final int generateSpeed;

  /// 点击事件
  final Function()? onTap;

  /// 字体大小
  final double fontSize;

  const MatrixEffect({
    this.characters,
    this.onTap,
    this.initCount = 2,
    this.generateSpeed = 800,
    this.fontSize = 36.0,
    Key? key,
  }) : super(key: key);

  @override
  _MatrixEffectState createState() => _MatrixEffectState();
}

class _MatrixEffectState extends State<MatrixEffect> {
  List<Widget> verticalLines = [];
  Timer? _timer;

  List<double> filter = [1.0, 0.6, 0.4];

  /// 单列所能容纳的字数
  int fontCount = 0;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
      _startTime();
    });
  }

  void initData() {
    fontCount = MediaQuery.of(context).size.height ~/ widget.fontSize + 1;
  }

  List<String> generateCharacters() {
    List<String> showCharacters = [];
    for (int i = 0; i < fontCount; i++) {
      if (widget.characters == null || widget.characters!.isEmpty) {
        showCharacters.add(String.fromCharCode(_random.nextInt(512)));
      } else {
        showCharacters.add(
            widget.characters![_random.nextInt(widget.characters!.length)]);
      }
    }
    return showCharacters;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTime() {
    if (fontCount == 0) return;
    _timer =
        Timer.periodic(Duration(milliseconds: widget.generateSpeed), (timer) {
          setState(() {
            for (int i = 0; i < widget.initCount; i++) {
              verticalLines.add(_getVerticalTextLine(context));
            }
          });
        });
  }

  Widget _getVerticalTextLine(BuildContext context) {
    Key key = GlobalKey();
    double temp = filter[_random.nextInt(filter.length)];
    double fontSize = widget.fontSize * temp;
    double opacity = temp;
    return Positioned(
        key: key,
        left: Random().nextDouble() * MediaQuery.of(context).size.width,
        child: VerticalProgressiveTextLine(
          characters: generateCharacters(),
          fontSize: fontSize,
          opacity: opacity,
          scaleMode: temp > 0.6
              ? Scale.zoomIn
              : temp > 0.4
              ? Scale.normal
              : Scale.zoomOut,
          onFinish: () {
            setState(() {
              verticalLines.removeWhere((element) {
                return element.key == key;
              });
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: verticalLines,
        ),
      ),
    );
  }
}

class VerticalProgressiveTextLine extends StatefulWidget {
  final List<String> characters;
  final Function() onFinish;
  final double fontSize;
  final double opacity;
  final Scale scaleMode;
  final double scaleSpeed;
  const VerticalProgressiveTextLine(
      {required this.characters,
        required this.onFinish,
        required this.fontSize,
        required this.scaleMode,
        this.opacity = 0.0,
        this.scaleSpeed = 0.0002,
        Key? key})
      : super(key: key);

  @override
  _VerticalProgressiveTextLineState createState() =>
      _VerticalProgressiveTextLineState();
}

class _VerticalProgressiveTextLineState
    extends State<VerticalProgressiveTextLine> {
  Timer? _timer;

  double speed = 1.0;

  // 是否加速
  bool accelerate = false;

  // 缩放比例
  double scale = 1.0;

  List<Color> colors = [];

  List<double> stops = [];

  @override
  void initState() {
    initData();
    startTimer();
    super.initState();
  }

  void initData() {
    colors = [
      Colors.transparent,
      Colors.green.withOpacity(widget.opacity),
      Colors.green.withOpacity(widget.opacity),
      Colors.white.withOpacity(widget.opacity),
      Colors.white.withOpacity(widget.opacity),
      Colors.transparent,
    ];
    stops = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      speed = speed * 1.001;
      setState(() {
        stops[0] += 0.0015 * speed;
        stops[1] += 0.0035 * speed;
        stops[5] += 0.01 * speed;
        stops[4] = stops[5];
        stops[3] = stops[5] - 1 / 23;
        stops[2] = stops[3] - 1 / 23;
        if (widget.scaleMode == Scale.zoomIn) {
          scale += widget.scaleSpeed;
        } else if (widget.scaleMode == Scale.zoomOut) {
          scale -= widget.scaleSpeed;
        }
      });
      if (stops[5] >= 1.0 && !accelerate) {
        accelerate = true;
        speed = speed * 2.0;
      }
      if (stops[0] >= 1.0) {
        widget.onFinish.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      origin: Offset(MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2),
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: stops,
              colors: colors,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (String chara in widget.characters)
                Text(chara,
                    style: TextStyle(
                        color: Colors.white, fontSize: widget.fontSize))
            ],
          )),
    );
  }
}
