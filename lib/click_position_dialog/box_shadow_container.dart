import 'package:flutter/material.dart';

/// guoshijun created this file at 2022/5/10 5:26 下午
///
/// 带阴影的Container

Widget boxShadowContainer(
    {required double height,
    required double width,
    required Widget child,
    Color color = Colors.white,
    Color shadowColor = Colors.grey,
    double borderRadius = 10.0,
    double blurRadius = 100.0}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: blurRadius)],
        color: color,
        borderRadius: BorderRadius.circular(borderRadius)),
    child: child,
  );
}
