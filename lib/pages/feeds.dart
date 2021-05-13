import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nine_levelv6/chats/recent_chats.dart';
import 'package:nine_levelv6/components/stream_builder_wrapper.dart';
import 'package:nine_levelv6/models/post.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/firebase.dart';
import 'package:nine_levelv6/videochats/home_page.dart';
import 'package:nine_levelv6/widgets/userpost.dart';

class Timeline extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/Isotipo2.png",
              width: 25,
              height: 24,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Nine Level',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill,
                size: 30.0, color: Constants.gradianButtom),
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => Chats()));
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.videocam_circle_fill,
                size: 30.0, color: Constants.gradianButtom),
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => HomePage()));
            },
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          StreamBuilderWrapper(
            shrinkWrap: true,
            stream: postRef.orderBy('timestamp', descending: true).snapshots(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, DocumentSnapshot snapshot) {
              internetChecker();
              PostModel posts = PostModel.fromJson(snapshot.data());
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                //  child: Posts(post: posts),
                child: UserPost(post: posts),
              );
            },
          ),
        ],
      ),
    );
  }

  internetChecker() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == false) {
      showInSnackBar('No Internet Connecton');
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
