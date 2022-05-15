import 'package:flutter/material.dart';
import 'box_shadow_container.dart';

/// guoshijun created this file at 2022/5/10 3:37 下午
///
/// 在点击位置生成弹出框

class ClickPositionDialogRoute extends PopupRoute {
  final Rect position;
  final double menuHeight;
  final double menuWidth;
  final List formList;

  ClickPositionDialogRoute(
      this.position, this.menuHeight, this.menuWidth, this.formList);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget _buildGrid() {
      List<Widget> titles = [];
      Widget content;
      for (var index = 0; index < formList.length; index++) {
        titles.add(
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () => {Navigator.of(context).pop(formList[index])},
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "${formList[index]}",
                  ),
                ),
              )),
        );
        if (index < formList.length - 1) {
          titles.add(
            Container(
              height: 0.8,
              color: Colors.grey.withOpacity(0.4),
            ),
          );
        }
      }
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: titles,
      );
      return content;
    }

    return CustomSingleChildLayout(
      delegate: _DropDownMenuRouteLayout(position, menuHeight, menuWidth),
      child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: boxShadowContainer(
            height: formList.length * 42.0,
            width: menuWidth,
            child: _buildGrid(),
          )),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "";
}

/// 下拉框布局
class _DropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect position;
  final double menuHeight;
  final double menuWidth;

  _DropDownMenuRouteLayout(this.position, this.menuHeight, this.menuWidth);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(Size(constraints.biggest.width, menuHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
        (position.left + position.right - menuWidth) / 2, position.bottom);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}
