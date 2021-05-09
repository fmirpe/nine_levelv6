import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:nine_levelv6/helpers/utils.dart';
import 'package:nine_levelv6/models/call.dart';
import 'package:nine_levelv6/resources/call_methods.dart';
import 'package:nine_levelv6/screens/callscreens/call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  @override
  void dispose() {
    // if (isCallMissed) {
    //   addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    // }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.call.callerPic,
                width: 150.0,
                height: 150.0,
              ),
            ),
            // CachedNetworkImage(
            //   imageUrl: widget.call.callerPic,
            //   width: 180.0,
            //   height: 180.0,
            // ),
            // CachedImage(
            //   widget.call.callerPic,
            //   isRound: true,
            //   radius: 180,
            // ),
            SizedBox(height: 10),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 30),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      FlutterRingtonePlayer.stop();
                      await handlePermissionsForCall(context)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
