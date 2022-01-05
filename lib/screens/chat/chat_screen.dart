import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/const/user_status.dart';
import 'package:tinh/helper/custom_cache_manager.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/file_picker_widget.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/screens/chat/components/voice_chat_widget.dart';
import 'package:tinh/screens/chat/components/voice_recorder.dart';
import 'package:tinh/services/chat/chat_service.dart';
import 'package:tinh/widgets/show_full_scren_image_widget.dart';

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
  TextEditingController _userNameController = TextEditingController();
  String getName = '';
  int lastDataIndex = 0;
  bool isShowLoading = false;
  //
  void _onSendTextMessage() {
    if (textController.text.isNotEmpty) {
      chatService.chatText(textController.text, '', '', widget.tokenDoc, isShopOwner ? 1 : 0);
      chatService.addUnread(textController.text, widget.tokenDoc, _userNameController.text.isEmpty ? getName : _userNameController.text);
      textController.text = '';
      showListViewLastIndex();
    }
  }

  void _onSendVoice(File file) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        isShowLoading = true;
      });
      await chatService.addVoiceToFirebase(DateTime.now().toString(), file).then((value) {
        chatService.chatText('', '', value, widget.tokenDoc, isShopOwner ? 1 : 0);
        chatService.addUnread('sent a voice message', widget.tokenDoc, _userNameController.text.isEmpty ? getName : _userNameController.text);
      }).whenComplete(() {
        setState(() {
          isShowLoading = false;
        });
      });
    });
  }

  void _onSendImage() {
    Future.delayed(Duration.zero, () async {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          isShowLoading = true;
        });
        await chatService.addAttachmentToFirebase(DateTime.now().toString(), image).then((value) {
          chatService.chatText('', value, '', widget.tokenDoc, isShopOwner ? 1 : 0);
          chatService.addUnread('sent an image', widget.tokenDoc, _userNameController.text.isEmpty ? getName : _userNameController.text);
        }).whenComplete(() {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

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
      Future.delayed(Duration.zero, () async {
        await chatService.getName(widget.tokenDoc).then((value) => {getName = value});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorsConts.primaryColor,
          title: Text(widget.name),
        ),
        body: Material(
          child: Container(
            child: SafeArea(child: _buildBody()),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        isShowLoading ? WidgetHelper.loadingWidget(context, MediaQuery.of(context).size.height) : SizedBox.shrink(),
        Column(
          children: [
            Expanded(child: _chatList()),
            _textingArea(),
          ],
        ),
      ],
    );
  }

  Widget _chatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('CHAT').doc(widget.tokenDoc).collection('messages').orderBy('sentDate', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String name = '';

          if (_userNameController.text.isEmpty) {
            if (getName.isEmpty) {
              name = widget.name;
            } else {
              name = getName;
            }
          }

          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                  controller: controller,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    if (isShopOwner) {
                      chatService.changeUnread(widget.tokenDoc, name);
                    }
                    showListViewLastIndex();

                    Widget child = Container();
                    if (doc['image-url'].toString().isNotEmpty) {
                      child = _chatImageItem(doc['image-url'], doc['sentBy'] == isOwner);
                    } else if (doc['voice-url'].toString().isNotEmpty) {
                      child = _chatVoiceItem(doc['voice-url'], doc['sentBy'] == isOwner);
                    } else {
                      child = _buildChatItem(doc['message'], doc['sentBy'] == isOwner);
                    }

                    return Align(alignment: doc['sentBy'] == isOwner ? Alignment.topRight : Alignment.centerLeft, child: child);
                  })
              : WidgetHelper.noDataFound();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _chatVoiceItem(String url, bool isSender) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(color: isSender ? Colors.blue : Colors.grey, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(5),
      child: ChatAudioPlayer(
        url: url,
        type: ChatAudioPlayerType.slider,
      ),
    );
  }

  Widget _chatImageItem(String url, bool isSender) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(context, ShowFullScreenFirebaseImage(url: url));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: isSender ? Colors.blue : Colors.grey, width: 2), borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        width: 150,
        height: 150,
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager(),
          fit: BoxFit.fill,
          imageUrl: url,
          errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
        ),
      ),
    );
  }

  Widget _buildChatItem(String message, bool isSender) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(color: isSender ? Colors.blue : Colors.grey, borderRadius: BorderRadius.circular(20)),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _textingArea() {
    return !showVoiceRecordButton
        ? Container(
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
                                    _onSendImage();
                                  });
                                },
                                child: _buildIcon(FontAwesomeIcons.image)),
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
          )
        : _voicRecord();
  }

  Widget _voicRecord() {
    return Column(
      children: [
        Container(
          color: Colors.grey.withOpacity(.05),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    showVoiceRecordButton = !showVoiceRecordButton;
                  });
                },
                child: Icon(FontAwesomeIcons.times)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 12, right: 12),
          child: ChatAudioRecorderWidget(
            sendVoidCallBack: (File? voice) {
              setState(() {});
              if (voice != null) {
                showVoiceRecordButton = !showVoiceRecordButton;
                _onSendVoice(voice);
              }
            },
          ),
        ),
      ],
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

class ShowFullScreenFirebaseImage extends StatelessWidget {
  final String url;
  const ShowFullScreenFirebaseImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager(),
                  fit: BoxFit.contain,
                  imageUrl: url,
                  errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
                ),
              ),
              Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Center(
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        )),
                  ))
            ],
          )),
    );
  }
}
