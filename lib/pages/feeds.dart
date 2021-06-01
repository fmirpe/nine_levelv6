import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nine_levelv6/chats/recent_chats.dart';
import 'package:nine_levelv6/components/stream_builder_wrapper.dart';
import 'package:nine_levelv6/models/post.dart';
import 'package:nine_levelv6/models/story_model.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/services/stories_service.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/firebase.dart';
import 'package:nine_levelv6/videochats/home_page.dart';
import 'package:nine_levelv6/view_models/user/user_view_model.dart';
import 'package:nine_levelv6/widgets/indicators.dart';
import 'package:nine_levelv6/widgets/story_view.dart';
import 'package:nine_levelv6/widgets/userpost.dart';
import 'package:nine_levelv6/widgets/userpostvideo.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  Timeline();
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoadingStories = false;
  List<UserModel> _followingUsersWithStories = [];
  List<CameraDescription> _cameras;

  Future<List<CameraDescription>> getCameras() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (_) {
      showInSnackBar('Cant get cameras!');
    }

    return _cameras;
  }

  @override
  void initState() {
    super.initState();
    _setupStories();
    getCameras();
  }

  void _setupStories() async {
    setState(() => _isLoadingStories = true);
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();
    var user = viewModel.user;
    // Get currentUser followingUsers
    List<UserModel> followingUsers =
        await viewModel.getUserFollowingUsers(user.uid);

    if (!mounted) return;
    UserModel currentUser = await viewModel.getUser(viewModel.user.uid);

    // List<Story> currentUserStories =
    //     await StoriesService.getStoriesByUserId(currentUser.id, true);

    // Add current user to the first story circle
    // followingUsers.insert(0, currentUser);

    // if (currentUserStories != null) {
    // }

    /* A method to add Admin stories to each user */
    if (currentUser.id != "kAdminUId") {
      bool isFollowingAdmin = false;

      for (UserModel user in followingUsers) {
        if (user.id == "kAdminUId") {
          isFollowingAdmin = true;
        }
      }
      // if current user doesn't follow admin
      if (!isFollowingAdmin) {
        // get admin stories
        List<Story> adminStories =
            await StoriesService.getStoriesByUserId("kAdminUId", true);
        if (!mounted) return;
        // if there is admin stories
        if (adminStories != null && adminStories.isNotEmpty) {
          // get admin user
          // UserModel adminUser = await DatabaseService.getUserWithId("kAdminUId");
          // if (!mounted) return;
          // // add admin to story circle list
          // followingUsers.insert(0, adminUser);
        }
      }
    }
    /* End of method to add Admin stories to each user */

    if (mounted) {
      setState(() {
        _isLoadingStories = false;
        _followingUsersWithStories = followingUsers;
      });
    }
  }

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
              Constants.appName,
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
          //_isLoadingStories           ?
          // Container(
          //   height: 88,
          //   child: Center(
          //     child: circularProgress(context),
          //   ),
          // ),
          StoryItems(),
          // : StoriesWidget(
          //     _followingUsersWithStories,
          //   ),
          SizedBox(height: 5),
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
                child: posts.type == 1
                    ? UserPost(post: posts)
                    : UserPostVideo(post: posts),
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
