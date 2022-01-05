import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:tinh/helper/date_helper.dart';
import 'package:path/path.dart' as path;

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

  void chatText(String message, String imageUrl, String voiceUrl, String tokenDoc, int isShopOwner) {
    Map<String, dynamic> data = {
      'message': message,
      'image-url': imageUrl,
      'voice-url': voiceUrl,
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

  Future<String> addVoiceToFirebase(String createdDate, File file) async {
    String fileName = path.basename(file.path);
    String name = DateHelper.format(DateTime.parse(createdDate), dateFormatddMMyyy) + fileName;

    //
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('voices/').child('/${name}');
    await ref.putFile(file).then((p0) {
      if (p0.state == firebase_storage.TaskState.success) {}
    });

    return await firebase_storage.FirebaseStorage.instance.ref().child('voices/' + name).getDownloadURL();
  }

  Future<String> addAttachmentToFirebase(String createdDate, XFile? file) async {
    File getFile = File(file!.path);

    String fileName = path.basename(file.path);
    String name = DateHelper.format(DateTime.parse(createdDate), dateFormatddMMyyy) + fileName;

    //
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images').child('/${name}');
    await ref.putFile(getFile).then((p0) {
      if (p0.state == firebase_storage.TaskState.success) {}
    });

    return await firebase_storage.FirebaseStorage.instance.ref().child('images/' + name).getDownloadURL();
  }
}

ChatService chatService = ChatService();
