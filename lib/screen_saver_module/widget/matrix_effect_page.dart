import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class MatrixEffect extends StatefulWidget {
  /// 数据集
  final List<String> characters;

  /// 单次生成词组数量
  final int initCount;

  /// 生成速度(单位：毫秒)
  final int generateSpeed;

  /// 点击事件
  final Function()? onTap;

  const MatrixEffect({
    required this.characters,
    this.onTap,
    this.initCount = 2,
    this.generateSpeed = 500,
    Key? key,
  }) : super(key: key);

  @override
  _MatrixEffectState createState() => _MatrixEffectState();
}

class _MatrixEffectState extends State<MatrixEffect> {
  List<Widget> verticalLines = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTime() {
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
    return Positioned(
      key: key,
      left: Random().nextDouble() * MediaQuery.of(context).size.width,
      child: VerticalTextLine(
        characters: widget.characters,
        speed: Random().nextInt(10) + Random().nextDouble(),
        maxLength: Random().nextInt(10) + 5,
        onFinished: () {
          setState(() {
            verticalLines.removeWhere((element) {
              return element.key == key;
            });
          });
        },
      ),
    );
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

class VerticalTextLine extends StatefulWidget {
  final double speed;
  final int maxLength;
  final List<String> characters;
  final VoidCallback onFinished;
  const VerticalTextLine(
      {required this.onFinished,
        required this.characters,
        this.speed = 12.0,
        this.maxLength = 10,
        Key? key})
      : super(key: key);

  @override
  _VerticalTextLineState createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  late Duration _stepInterval;
  Timer? _timer;

  List<String> generateCharacters = [];

  @override
  void initState() {
    _stepInterval = Duration(milliseconds: (1000 ~/ widget.speed));
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(_stepInterval, (timer) {
      final _random = Random();
      String element =
      widget.characters[_random.nextInt(widget.characters.length)];

      setState(() {
        generateCharacters.add(element);
      });

      /// 结束标记
      final box = context.findRenderObject() as RenderBox;
      if (box.size.height > MediaQuery.of(context).size.height * 1.3) {
        widget.onFinished();
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
    List<Color> colors = [
      Colors.transparent,
      Colors.green,
      Colors.green,
      Colors.white
    ];
    late double greenStart;
    double whiteStart =
        (generateCharacters.length - 1) / (generateCharacters.length);
    if (((generateCharacters.length - widget.maxLength) /
        generateCharacters.length) <
        0.3) {
      greenStart = 0.3;
    } else {
      greenStart = (generateCharacters.length - widget.maxLength) /
          generateCharacters.length;
    }

    List<double> stops = [0, greenStart, whiteStart, whiteStart];

    return SingleChildScrollView(
      child: _getShaderMask(stops, colors),
    );
  }

  ShaderMask _getShaderMask(List<double> stops, List<Color> colors) {
    return ShaderMask(
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
            for (String chara in generateCharacters)
              Text(chara, style: const TextStyle(color: Colors.white))
          ],
        ));
  }
}