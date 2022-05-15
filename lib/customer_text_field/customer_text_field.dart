import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// guoshijun created this file at 2022/5/16 12:00 上午
///
/// 自定义密码输入框

class CustomerTextField extends StatefulWidget {
  final Function(List<String>)? textChange;

  /// 元素个数
  final int itemCount;

  /// 未输入时颜色
  final Color enableColor;

  /// 输入中颜色
  final Color focusColor;

  /// 光标颜色
  final Color cursorColor;

  /// 文本颜色
  final Color textColor;

  /// 输入完成颜色
  final Color completeColor;

  /// 校验规则
  final String regExp;

  /// 每个输入框限制输入数量
  final int inputNum;

  /// 是否不允许随意输入
  final bool limited;

  const CustomerTextField(
      {this.textChange,
      this.itemCount = 6,
      this.enableColor = Colors.red,
      this.focusColor = Colors.red,
      this.cursorColor = Colors.red,
      this.textColor = Colors.red,
      this.completeColor = const Color.fromARGB(255, 169, 172, 183),
      this.regExp = "[0-9]",
      this.inputNum = 1,
      this.limited = true,
      Key? key})
      : super(key: key);

  @override
  _CustomerTextFieldState createState() => _CustomerTextFieldState();
}

class _CustomerTextFieldState extends State<CustomerTextField> {
  /// 缓存文本输入列表
  List<String> inputList = [];

  /// 缓存焦点列表
  List<FocusNode> focusNodeList = [];

  @override
  void initState() {
    List.generate(widget.itemCount,
        (index) => {focusNodeList.add(FocusNode()), inputList.add("")});
    super.initState();
  }

  ///获取焦点
  _getFocus(index) {
    FocusScope.of(context).requestFocus(focusNodeList[index]);
  }

  ///失去焦点
  _loseFocus(index) {
    focusNodeList[index].unfocus();
  }

  Widget _textField({required int index}) {
    TextEditingController _controller =
        TextEditingController(text: inputList[index]);
    _controller.selection = TextSelection.fromPosition(TextPosition(
        affinity: TextAffinity.downstream, offset: inputList[index].length));
    return SizedBox(
      width: MediaQuery.of(context).size.width / (widget.itemCount + 2),
      child: TextField(
        controller: _controller,
        focusNode: focusNodeList[index],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(widget.regExp)),
        ],
        cursorColor: widget.cursorColor,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: widget.textColor,
            fontSize: 24.0,
            fontWeight: FontWeight.bold),
        onTap: () {
          if (widget.limited) {
            int needInputIndex = inputList.indexOf('');
            if (needInputIndex == -1) {
              needInputIndex = widget.itemCount - 1;
            }
            if (needInputIndex - 1 == index) {
              needInputIndex = index;
            }
            _getFocus(needInputIndex);
          }
        },
        onChanged: (value) {
          var temValue = value;
          if (value.length > 1) {
            temValue = value[value.length - 1];
          }
          setState(() {
            inputList[index] = temValue;
          });
          widget.textChange?.call(inputList);
          if (value.isEmpty) {
            if (index > 0) {
              _getFocus(index - 1);
            } else {
              _loseFocus(index);
            }
          } else if (value.isNotEmpty && value.length >= widget.inputNum) {
            if (index < widget.itemCount - 1) {
              _getFocus(index + 1);
            } else {
              _loseFocus(index);
            }
          }
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              borderSide: BorderSide(color: widget.focusColor, width: 5)),
          enabledBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              borderSide: BorderSide(
                  color: inputList[index].isNotEmpty
                      ? widget.completeColor
                      : widget.enableColor,
                  width: 5)),
          disabledBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              borderSide: BorderSide(
                  color: inputList[index].isNotEmpty
                      ? widget.completeColor
                      : widget.enableColor,
                  width: 5)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          List.generate(widget.itemCount, (index) => _textField(index: index))
              .toList(),
    );
  }
}
