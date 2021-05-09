import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nine_levelv6/models/call.dart';
import 'package:nine_levelv6/utils/firebase.dart';

class CallMethods {
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callsRef.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callsRef.doc(call.callerId).set(hasDialledMap);
      await callsRef.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callsRef.doc(call.callerId).delete();
      await callsRef.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
