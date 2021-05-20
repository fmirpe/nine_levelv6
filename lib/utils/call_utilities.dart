import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nine_levelv6/models/call.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/resources/call_methods.dart';
import 'package:nine_levelv6/screens/callscreens/call_screen.dart';
//import 'package:nine_levelv6/screens/callscreens/call_screen_old.dart';
//import 'package:nine_levelv6/screens/callscreens/call_screen_call.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from, UserModel to, String typecall, context}) async {
    Call call = Call(
      callerId: from.id,
      callerName: from.username,
      callerPic: from.photoUrl,
      receiverId: to.id,
      receiverName: to.username,
      receiverPic: to.photoUrl,
      typecall: typecall,
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
      if (call.typecall == "Video") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ),
        );
      } else {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CallScreenCall(call: call),
        //   ),
        // );
      }
    }
  }
}
