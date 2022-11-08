import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// 测试蓝牙连接状态及监听设备变化

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {

  Stream? devicesChangedEventStream;

  AudioSession? _session;
  
  void initSession() async {
    _session = await AudioSession.instance;
    await _session?.configure(const AudioSessionConfiguration.music());
    print("开始监听....");

    _session?.devicesChangedEventStream.listen((event) {
      print('Device111 added: ${event.devicesAdded}');
      print('Device222 remove: ${event.devicesRemoved}');
    });

    _session?.becomingNoisyEventStream.listen((event) {
      print("摘掉耳机/断开连接");
    });

    _session?.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
    });

    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
      // await _player.setAsset('assets/audio/test.mp3');
      print("设置源成功...");
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void getDevices() async {
    _player.play();
    print('开始播放。。。。');
    // Set<AudioDevice> devices = await _session!.getDevices();
    // for (var element in devices) {
    //   print("这里的值：${element.toString()}");
    // }
  }


  final _player = AudioPlayer();
  
  @override
  void initState() {
    initSession();
    super.initState();
  }
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('外设变化'),),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()=>getDevices(),
              child: Text('设备添加'),
            )
          ],
        ),
      ),
    );
  }
}
