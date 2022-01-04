import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/const/user_status.dart';
import 'package:tinh/helper/device_infor.dart';
import 'package:tinh/helper/navigation_helper.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/screens/chat/chat_screen.dart';
import 'package:tinh/services/chat/chat_service.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConts.primaryColor,
        title: Text('ទំនាក់ទំនង'),
      ),
      body: Material(
        child: SafeArea(
            child: Container(
          child: _builBody(),
        )),
      ),
    );
  }

  Widget _builBody() {
    return _listName();
  }

  Widget _listName() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('CHAT').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return _item(doc['name'], doc['unread-message'], snapshot.data!.docs[index].id);
                  })
              : WidgetHelper.noDataFound();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _item(String name, String unreadMessage, String tokenDoc) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: unreadMessage.isNotEmpty ? Colors.blue.withOpacity(.7) : Colors.grey,
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(.5),
            )
          ],
          border: Border.all(color: Colors.white, width: 2)),
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => NavigationHelper.push(
              context,
              ChatScreen(
                name: name,
                tokenDoc: tokenDoc,
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                unreadMessage.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'message:\t\t' + unreadMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
