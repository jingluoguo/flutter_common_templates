/// 原生
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 第三方
import 'package:video_player/video_player.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

///本地
import 'bubble.dart';

/// 气球聊天详情页
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  /// 用户头像
  Widget userAvatar(img, size) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(img),
      ),
    );
  }

  /// 通用简单text格式
  singleTextWeight(text, color, fontSize) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fontSize),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 通用获取安全顶部距离
  Widget safePadding(BuildContext context, color) {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: color,
    );
  }

  /// 隐藏键盘
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  ScrollController scrollController = ScrollController();

  /// 消息列表
  var _messageList = [];

  /// 输入框焦点
  FocusNode focusNode = FocusNode();

  late VideoPlayerController _controller; //背景视频播放控制器

  var _visZhifeiji = true; //发送按钮隐藏和显示
  final bool _isText = true; //true文本输入  false语言输入
  final TextEditingController _messageText =
      TextEditingController(); //需要初始化的时候赋值用
  bool emojiShowing = false;

  /// 是否显示表情
  bool keyboardShowing = false;

  /// 是否显示键盘

  /// 获取用户历史消息
  getHistoryMessages() async {
    setState(() {
      _messageList = [
        {"messageDirection": 1, "content": "还好"},
        {"messageDirection": 2, "content": "最近还好吗？"},
        {"messageDirection": 1, "content": "是啊"},
      ];
    });
  }

  @override
  void initState() {
    ///初始化视频播放
    _controller = VideoPlayerController.network(
        'https://gugu-1300042725.cos.ap-shanghai.myqcloud.com/0_szDjEDn.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setVolume(0);
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();

    getHistoryMessages();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        keyboardShowing = true;
        if (emojiShowing) {
          setState(() {
            emojiShowing = !emojiShowing;
          });
        }
      } else {
        keyboardShowing = false;
      }
    });

    super.initState();
  }

  ///选中表情
  _onEmojiSelected(Emoji emoji) {
    setState(() {
      _visZhifeiji = false;
    });
    _messageText
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageText.text.length));
  }

  ///表情删除按钮
  _onBackspacePressed() {
    _messageText
      ..text = _messageText.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageText.text.length));
    if (_messageText.text.isNotEmpty) {
      setState(() {
        _visZhifeiji = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); //移除监听
    scrollController.dispose();
    super.dispose();
  }

  /// 头部 Banner
  Widget _buildHeader(context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: 30.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Row(
                children: [
                  GestureDetector(
                    child: const Text("返回"),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(child: Text("")),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Center(
                child: singleTextWeight("Jaycee", Colors.white, 16.0),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: const Text(""),
            ),
          ],
        ),
      ),
    );
  }

  /// 渲染聊天内容
  next(_messageRealList, index) {
    return Row(
      children: [
        _messageRealList[index]['messageDirection'] == 1
            ? const Expanded(child: Text(""))
            : userAvatar(
                "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202005%2F06%2F20200506110929_iajqi.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1631409536&t=03cad8232b224d6a7ff11f58ff2be920",
                58.0),
        GestureDetector(
          onTap: () => {},
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 128.0),
            child: Bubble(
                direction: _messageRealList[index]['messageDirection'] == 1
                    ? BubbleDirection.right
                    : BubbleDirection.left,
                color: Colors.blueAccent,
                child: Text(
                  "${_messageRealList[index]['content']}",
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                )),
          ),
        ),
        _messageRealList[index]['messageDirection'] != 1
            ? const Expanded(child: Text(""))
            : userAvatar(
                "https://img.win3000.com/m00/06/ac/9e46cfd309a8aa2c7ef0b16ed50296be_c_345_458.jpg",
                58.0),
      ],
    );
  }

  /// 渲染聊天部分
  Widget _chatList(BuildContext context) {
    List _messageRealList = _messageList.reversed.toList();
    if (scrollController.hasClients &&
        scrollController.position.maxScrollExtent != 0.0) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    return Column(
      children: [
        safePadding(context, Colors.transparent),
        _buildHeader(context),
        Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width - 40.0,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: singleTextWeight("好久不见", Colors.white, 16.0),
          ),
        ),
        Expanded(
            child: CustomScrollView(controller: scrollController, slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => next(_messageRealList, index),
              childCount: _messageList.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 312.0 / 60.0,
            ),
          )
        ])),

        ///输入键盘
        Container(
          color: const Color(0x0dffffff),
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          height: 60.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 13, 0),
                  width: 34.0,
                  height: 34.0,
                  child: _isText
                      ? Image.asset("assets/chat/button_voice.png")
                      : Image.asset("assets/chat/button_keyboard.png"),
                ),
                // onTap: () {
                //   if (this._isText) {
                //     this._isText = false;
                //     this.emojiShowing = false;
                //     this._visZhifeiji = true;
                //   } else {
                //     this._isText = true;
                //   }
                // },
              ),
              Expanded(
                flex: 1,
                child: _isText
                    ? TextFormField(
                        focusNode: focusNode,
                        controller: _messageText,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: '请输入',
                            hintStyle: TextStyle(
                                fontSize: 18, color: Color(0x80ffffff))),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _visZhifeiji = true;
                            });
                          } else {
                            _visZhifeiji = false;
                          }
                        },
                      )
                    : const Text("data"),
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 6, 0),
                  width: 30.0,
                  height: 30.0,
                  child: Image.asset("assets/chat/button_emoji.png"),
                ),
                onTap: () {
                  hideKeyboard(context);
                  Future.delayed(const Duration(milliseconds: 10), () {
                    setState(() {
                      emojiShowing = !emojiShowing;
                    });
                    if (emojiShowing) {
                      scrollController.jumpTo(
                          scrollController.position.maxScrollExtent + 250.0);
                    }
                  });
                },
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(6, 0, 15, 0),
                  width: 34.0,
                  height: 34.0,
                  child: Image.asset("assets/chat/button_add.png"),
                ),
                // onTap:(){
                // _onImageButtonPressed(ImageSource.camera, context: context);//打开相机
                // }
              ),
              Offstage(
                offstage: _visZhifeiji,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  width: 32.0,
                  height: 32.0,
                  child: InkWell(
                    child: Image.asset("assets/chat/button_paper_plane.png"),
                    onTap: () {
                      setState(() {
                        _visZhifeiji = true;
                        _messageList.insert(0, {
                          "messageDirection": 1,
                          "content": _messageText.text
                        });
                      });
                      // this.getHistoryMessages();
                      _messageText.text = "";
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        ///表情
        Offstage(
          offstage: !emojiShowing,
          child: SizedBox(
            height: 250.0,
            width: 1000.0,
            child: EmojiPicker(
              onEmojiSelected: (Category? category, Emoji emoji){
                _onEmojiSelected(emoji);
              },
                onBackspacePressed: _onBackspacePressed,
                config: const Config(
                    columns: 7,
                    emojiSizeMax: 25.0,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    initCategory: Category.RECENT,
                    bgColor: Color(0xFFF2F2F2),
                    indicatorColor: Color(0xff65DAC5),
                    iconColor: Colors.orange,
                    iconColorSelected: Color(0xff65DAC5),
                    // progressIndicatorColor: Color(0xff65DAC5),
                    backspaceColor: Color(0xff65DAC5),
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecents: Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ), //
                    categoryIcons: CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: KeyboardVisibilityBuilder(
          /// 检测键盘是否弹出
          builder: (context, isKeyboardVisible) {
            if (isKeyboardVisible && !mounted) {
              /// 当键盘弹出时自动跳转到最底部
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
            return GestureDetector(
              onTap: () => {
                hideKeyboard(context),

                /// 隐藏键盘
                emojiShowing = false
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/healing/icon_background.png",
                        ),
                        fit: BoxFit.fill)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _controller.value.isInitialized
                        ? Transform.scale(
                            scale: _controller.value.aspectRatio /
                                MediaQuery.of(context).size.aspectRatio,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          )
                        : Image.asset("assets/healing/icon_background.png"),
                    Scaffold(
                        backgroundColor: Colors.transparent,
                        body: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: _chatList(context),
                        ))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
