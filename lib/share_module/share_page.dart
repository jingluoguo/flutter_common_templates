import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {

  void share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      'xxxxx ',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分享'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(builder: (BuildContext context) {
              return GestureDetector(
                onTap: ()=>share(context),
                child: Container(
                  height: 48.0,
                  width: 100.0,
                  color: Colors.cyanAccent,
                  child: const Center(
                    child: Text("分享"),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
