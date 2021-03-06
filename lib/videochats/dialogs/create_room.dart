import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_levelv6/helpers/text_styles.dart';
import 'package:nine_levelv6/helpers/utils.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/videochats/videocall_page.dart';

class CreateRoomDialog extends StatefulWidget {
  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  String roomId = "";
  @override
  void initState() {
    roomId = generateRandomString(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Room Created"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/room_created_vector.png',
          ),
          Text(
            "Room id : " + roomId,
            style: midTxtStyle.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Constants.lightButtom,
                onPressed: () {
                  shareToApps(roomId);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Share",
                      style: regularTxtStyle,
                    ),
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Constants.lightButtom,
                onPressed: () async {
                  bool isPermissionGranted =
                      await handlePermissionsForCall(context);
                  if (isPermissionGranted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          channelName: roomId,
                        ),
                      ),
                    );
                  } else {
                    Get.snackbar("Failed",
                        "Microphone Permission Required for Video Call.",
                        backgroundColor: Colors.white,
                        colorText: Color(0xFF1A1E78),
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Join",
                      style: regularTxtStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
