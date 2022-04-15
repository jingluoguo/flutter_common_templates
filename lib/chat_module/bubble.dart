import 'package:flutter/material.dart';

const _arrowWidth = 7.0;    //箭头宽度
const _arrowHeight = 10.0;  //箭头高度
const _minHeight = 32.0;    //内容最小高度
const _minWidth = 50.0;     //内容最小宽度

class Bubble extends StatelessWidget {
  final BubbleDirection direction;
  final Radius? borderRadius;
  final Widget? child;
  final BoxDecoration? decoration;
  final Color? color;
  final double _left;
  final double _right;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Alignment? alignment;
  const Bubble(
      {Key? key,
        this.direction = BubbleDirection.left,
        this.borderRadius,
        this.child, this.decoration, this.color, this.padding, this.margin, this.constraints, this.width, this.height, this.alignment})
      : _left = direction == BubbleDirection.left ? _arrowWidth : 0.0,
        _right = direction == BubbleDirection.right ? _arrowWidth : 0.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper:
      _BubbleClipper(direction, borderRadius ?? const Radius.circular(5.0)),
      child: Container(
        alignment: alignment,
        width: width,
        height: height,
        constraints: (constraints??const BoxConstraints()).copyWith(minHeight: _minHeight,minWidth: _minWidth),
        margin: margin,
        decoration: decoration,
        color: color,
        padding: EdgeInsets.fromLTRB(_left, 0.0, _right, 0.0).add(padding??const EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0)),
        child: child,
      ),
    );
  }
}

///方向
enum BubbleDirection { left, right }

class _BubbleClipper extends CustomClipper<Path> {
  final BubbleDirection direction;
  final Radius radius;
  _BubbleClipper(this.direction, this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    final path2 = Path();
    final centerPoint = (size.height / 2).clamp(_minHeight/2, _minHeight/2);
    if (direction == BubbleDirection.left) {
      //绘制左边三角形
      path.moveTo(0, centerPoint);
      path.lineTo(_arrowWidth, centerPoint - _arrowHeight/2);
      path.lineTo(_arrowWidth, centerPoint + _arrowHeight/2);
      path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(_arrowWidth, 0, (size.width - _arrowWidth), size.height), radius));
      //合并
      path.addPath(path2, const Offset(0, 0));
    } else {
      //绘制右边三角形
      path.moveTo(size.width, centerPoint);
      path.lineTo(size.width - _arrowWidth, centerPoint - _arrowHeight/2);
      path.lineTo(size.width - _arrowWidth, centerPoint + _arrowHeight/2);
      path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, (size.width - _arrowWidth), size.height), radius));
      //合并
      path.addPath(path2, const Offset(0, 0));
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

