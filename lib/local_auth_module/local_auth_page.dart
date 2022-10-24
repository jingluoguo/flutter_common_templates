import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthPage extends StatefulWidget {
  LocalAuthPage({Key? key}) : super(key: key);

  @override
  _LocalAuthPageState createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage> {
  var localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('指纹识别demo'),
        ),
        body: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                try {
                  bool canCheckBiometrics =
                  await localAuth.canCheckBiometrics;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('支持')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('不支持：$e')));
                }
              },
              child: const Text('检测是否支持生物识别'),
            ),
            const Divider(),
            RaisedButton(
              onPressed: () async {
                try {
                  List<BiometricType> availableBiometrics =
                  await localAuth.getAvailableBiometrics();
                  print(availableBiometrics);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('availableBiometrics:$availableBiometrics,为空可以查看是否未开启')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('不支持：$e')));
                }
              },
              child: const Text('获取支持的生物识别列表'),
            ),
            const Divider(),
            RaisedButton(
              onPressed: () async {
                try {
                  bool didAuthenticate =
                  await localAuth.authenticate(
                      localizedReason: '扫描指纹进行身份识别',
                      options: const AuthenticationOptions(useErrorDialogs: true));
                  print('didAuthenticate: $didAuthenticate');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('didAuthenticate: $didAuthenticate')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('不支持：$e')));
                }
              },
              child: const Text('指纹识别'),
            ),
            const Divider()
          ],
        ));
  }
}



