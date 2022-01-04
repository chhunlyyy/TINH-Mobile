import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/const/user_status.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String tokenDoc;
  const ChatScreen({Key? key, required this.tokenDoc, required this.name}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTexting = false;
  bool showAttachmentButton = false;
  bool showVoiceRecordButton = false;
  TextEditingController textController = TextEditingController();
  String deviceToken = '';
  int isOwner = isShopOwner ? 1 : 0;
  ScrollController controller = new ScrollController();

  int lastDataIndex = 0;
  //
  void _onSendTextMessage() {
    if (textController.text.isNotEmpty) {
      chatService.chatText(textController.text, widget.tokenDoc, isShopOwner ? 1 : 0);
      showListViewLastIndex();
    }
  }

  TextEditingController _userNameController = TextEditingController();
  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: _userNameController,
                    autofocus: true,
                    decoration: new InputDecoration(labelText: 'ឈ្មោះរបស់អ្នក', hintText: 'eg. John Smith'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    chatService.createChatDoc(deviceToken, _userNameController.text);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  void _checkExistChat() {
    Future.delayed(Duration.zero, () async {
      deviceToken = await DeviceInfoHelper.getDivceId();
      await chatService.checkHadChat(deviceToken).then((value) {
        if (!value) {
          _showDialog();
        }
      });
    });
  }

  void showListViewLastIndex() {
    Future.delayed(Duration.zero, () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!isShopOwner) {
      _checkExistChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConts.primaryColor,
        title: Text(widget.name),
      ),
      body: Material(
        child: Container(
          child: SafeArea(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(child: _chatList()),
        _textingArea(),
      ],
    );
  }

  Widget _chatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('CHAT').doc(widget.tokenDoc).collection('messages').orderBy('sentDate', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                  controller: controller,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    /* go to the last index when open */
                    if (snapshot.data!.docs.length == index + 1) {
                      showListViewLastIndex();
                    }
                    /* ...  */
                    /* if have new chat message go to the last index and make last message is read */
                    if (snapshot.data!.docs.length > lastDataIndex) {
                      lastDataIndex = snapshot.data!.docs.length;
                      showListViewLastIndex();
                    }
                    /* ...  */
                    return Align(
                        alignment: doc['sentBy'] == isOwner ? Alignment.topRight : Alignment.centerLeft,
                        child: Text(
                          doc['message'],
                        ));
                  })
              : WidgetHelper.noDataFound();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _textingArea() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !isTexting
                ? Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              showAttachmentButton = !showAttachmentButton;
                            });
                          },
                          child: _buildIcon(FontAwesomeIcons.folder)),
                      SizedBox(width: 20),
                      InkWell(
                          onTap: () {
                            setState(() {
                              showVoiceRecordButton = !showVoiceRecordButton;
                            });
                          },
                          child: _buildIcon(FontAwesomeIcons.microphone)),
                    ],
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        isTexting = !isTexting;
                      });
                    },
                    child: _buildIcon(FontAwesomeIcons.angleRight),
                  ),
            SizedBox(width: 20),
            Flexible(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    maxLines: null,
                    onTap: () {
                      setState(() {
                        isTexting = true;
                      });
                    },
                    controller: textController,
                    decoration: InputDecoration(hintText: 'Aa', border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            InkWell(
                onTap: () {
                  _onSendTextMessage();
                },
                child: _buildIcon(FontAwesomeIcons.paperPlane)),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Icon(
        icon,
        color: ColorsConts.primaryColor,
      ),
    );
  }
}
