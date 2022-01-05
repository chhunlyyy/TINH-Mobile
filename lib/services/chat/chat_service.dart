import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tinh/helper/date_helper.dart';

class ChatService {
  var instance = FirebaseFirestore.instance;
  final String collection = 'CHAT';
  Future<bool> checkHadChat(String token) async {
    bool resutl = false;
    var docRef = instance.collection(collection).doc(token);
    await docRef.get().then((value) {
      if (value.exists)
        resutl = true;
      else
        resutl = false;
    });
    return resutl;
  }

  void createChatDoc(String token, String userName) {
    Map<String, dynamic> data = {'name': userName, 'unread-message': ''};
    instance.collection(collection).doc(token).set(data);
  }

  void chatText(String message, String tokenDoc, int isShopOwner) {
    Map<String, dynamic> data = {
      'message': message,
      'sentBy': isShopOwner,
      'sentDate': DateTime.now(),
    };
    instance.collection(collection).doc(tokenDoc).collection('messages').doc().set(data);
  }

  void addUnread(String message, String token, String name) {
    instance.collection(collection).doc(token).set({'unread-message': message, 'name': name});
  }

  void changeUnread(String token, String name) {
    instance.collection(collection).doc(token).set({'unread-message': '', 'name': name});
  }

  Future<String> getName(String token) async {
    return await instance.collection(collection).doc(token).get().then((value) {
      return value['name'];
    });
  }
}

ChatService chatService = ChatService();
