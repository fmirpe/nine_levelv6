import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_levelv6/helpers/text_styles.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/videochats/dialogs/create_room.dart';
import 'package:nine_levelv6/videochats/dialogs/join_room.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF1A1E78),
      backgroundColor: Constants.lightButtom,
      appBar: AppBar(
        //scaffoldKey: widget.scaffoldKey,
        title: Text(
          'N9 Meeting',
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 30),
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "N9 Meeting",
                  style: largeTxtStyle.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                Text(
                  "Easy connect with friends via video call.",
                  style: largeTxtStyle.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                top: 30,
              ),
              padding: const EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Center(
                  child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return CreateRoomDialog();
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 7,
                                child: Image.asset(
                                  "assets/images/create_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Create Room",
                                    style: largeTxtStyle.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "create a unique agora room and ask others to join the same.",
                                    style: regularTxtStyle.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      margin: const EdgeInsets.all(20),
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return JoinRoomDialog();
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                              flex: 6,
                              child: Image.asset(
                                "assets/images/join_meeting_vector.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Join Room",
                                    style: largeTxtStyle.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Join a agora room created by your friend.",
                                    style: regularTxtStyle.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF1A1E78),
      //   child: Icon(Icons.thumb_up_alt_outlined),
      //   onPressed: () {
      //     Get.snackbar("Liked ?", "Please ★ My Project On Git :) ",
      //         backgroundColor: Colors.white,
      //         colorText: Color(0xFF1A1E78),
      //         snackPosition: SnackPosition.BOTTOM);
      //   },
      // ),
    );
  }
}
