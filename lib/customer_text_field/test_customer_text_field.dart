import 'package:flutter/material.dart';
import 'package:flutter_common_templates/customer_text_field/customer_text_field.dart';

/// guoshijun created this file at 2022/5/16 12:04 上午
///
/// 测试自定义文本输入框组件

class TestCustomerTextField extends StatelessWidget {
  const TestCustomerTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("自定义密码输入框"),
        ),
        body: const SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomerTextField(),
        ),
      ),
    );
  }
}
