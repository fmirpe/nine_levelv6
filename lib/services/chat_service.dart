import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nine_levelv6/models/message.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/utils/firebase.dart';

class ChatService {
  FirebaseStorage storage = FirebaseStorage.instance;

  sendMessage(Message message, String chatId) async {
    await chatRef.doc("$chatId").collection("messages").add(message.toJson());
    await chatRef.doc("$chatId").update({"lastTextTime": Timestamp.now()});
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    User user = firebaseAuth.currentUser;
    DocumentReference ref = await chatRef.add({
      'users': [recipient, user.uid],
    });
    await sendMessage(message, ref.id);
    return ref.id;
  }

  Future<String> uploadImage(File image, String chatId) async {
    Reference storageReference =
        storage.ref().child("chats").child(chatId).child(uuid.v4());
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  readMessage(String chatId, String user) async {
    var snapusuario = await usersRef.doc(user).get();

    var usuario = UserModel.fromJson(snapusuario.data());
    if (usuario.isOnline) {
      var messageunread = await chatRef
          .doc(chatId)
          .collection("messages")
          .where("senderUid", isEqualTo: usuario.id)
          .where("isRead", isEqualTo: false)
          .get();

      for (var i = 0; i < messageunread.docs.length; i++) {
        var messageId = messageunread.docs[i].id;
        await chatRef
            .doc(chatId)
            .collection("messages")
            .doc(messageId)
            .update({'isRead': true, 'timeisRead': Timestamp.now()});
      }
    }
  }

  setUserRead(String chatId, User user, int count) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map reads = {};
    var data = snap.data();
    if (data != null) {
      if (data.containsKey("reads")) {
        reads = snap.data()['reads'];
      }
    }

    reads[user?.uid] = count;
    await chatRef.doc(chatId).update({'reads': reads});
  }

  Future<int> getUserRead(String chatId, String user) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map reads = {};
    var data = snap.data();
    if (data != null) {
      if (data.containsKey("reads")) {
        reads = snap.data()['reads'];
      } else {
        return 0;
      }
    }
    int count = reads[user] == null ? 0 : reads[user];
    return count;
  }

  setUserTyping(String chatId, User user, bool userTyping) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map typing = {};
    var data = snap.data();
    if (data != null) {
      if (data.containsKey("reads")) {
        typing = snap.data()['typing'];
      }
    }

    typing[user?.uid] = userTyping;
    await chatRef.doc(chatId).update({
      'typing': typing,
    });
  }
}
