import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nine_levelv6/models/call.dart';
import './time_left.dart';

class ReceiverLeft extends StatefulWidget {
  final Call call;
  ReceiverLeft({this.call});
  @override
  _ReceiverLeftState createState() => _ReceiverLeftState();
}

class _ReceiverLeftState extends State<ReceiverLeft> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  Color(0xFF373A40),
                  Color(0xFF373A40),
                  Color(0xFF92817A),
                  Color(0xFF92817A),
                  Color(0xFF92817A),
                  Color(0xFF92817A),
                ])),
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // color: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  width: 180,
                  height: 180,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/spinner.gif",
                            image: widget.call.callerPic,
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.red,
                        ),
                      ),
                      Positioned(
                          left: 35,
                          top: 35,
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF92817A),
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/spinner.gif",
                                  image: widget.call.receiverPic,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.blue,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "Video chat ended",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                // Container(
                //   child: Column(
                //     children: [
                //       Text(
                //         "How was the quality of your ",
                //         softWrap: true,
                //         style: TextStyle(
                //             color: Colors.white, fontWeight: FontWeight.bold),
                //       ),
                //       Text(
                //         "video chat?",
                //         softWrap: true,
                //         style: TextStyle(
                //             color: Colors.white, fontWeight: FontWeight.bold),
                //       )
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Container(
                //   width: 260,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         width: 110,
                //         height: 40,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(20),
                //             border: Border.all(width: 1, color: Colors.white)),
                //         child: FlatButton(
                //           minWidth: 110,
                //           child: Text(
                //             "Good",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //           onPressed: () {},
                //         ),
                //       ),
                //       Container(
                //         width: 110,
                //         height: 40,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(20),
                //             border: Border.all(width: 1, color: Colors.white)),
                //         child: FlatButton(
                //           minWidth: 110,
                //           child: Text(
                //             "Poor",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //           onPressed: () {},
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 8,
            child: IconButton(
              icon: Icon(Entypo.cross, size: 32, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
