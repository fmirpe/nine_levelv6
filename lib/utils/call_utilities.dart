import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/helpers/strings.dart';
import 'package:nine_levelv6/models/call.dart';
import 'package:nine_levelv6/models/log.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/resources/call_methods.dart';
import 'package:nine_levelv6/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from, UserModel to, context}) async {
    Call call = Call(
      callerId: from.id,
      callerName: from.username,
      callerPic: from.photoUrl,
      receiverId: to.id,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      channelId: Random().nextInt(1000).toString(),
    );

    // Log log = Log(
    //   callerName: from.displayName,
    //   callerPic: from.photoURL,
    //   callStatus: CALL_STATUS_DIALLED,
    //   receiverName: to.displayName,
    //   receiverPic: to.photoURL,
    //   timestamp: DateTime.now().toString(),
    // );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}