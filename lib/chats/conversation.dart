import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nine_levelv6/helpers/utils.dart';
import 'package:nine_levelv6/screens/callscreens/pickup/pickup_layout.dart';
import 'package:nine_levelv6/utils/call_utilities.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/demo_active_codec.dart';
import 'package:nine_levelv6/utils/demo_common.dart';
import 'package:nine_levelv6/utils/recorder_state.dart';
import 'package:nine_levelv6/utils/temp_file.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:nine_levelv6/components/chat_bubble.dart';
import 'package:nine_levelv6/models/enum/message_type.dart';
import 'package:nine_levelv6/models/message.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/utils/firebase.dart';
import 'package:nine_levelv6/view_models/conversation/conversation_view_model.dart';
import 'package:nine_levelv6/view_models/user/user_view_model.dart';
import 'package:nine_levelv6/widgets/indicators.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';

class Conversation extends StatefulWidget {
  final String userId;
  final String chatId;

  const Conversation({@required this.userId, @required this.chatId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool isFirst = false;
  String chatId;

  bool initialized = false;

  String recordingFile;
  Track track;
  bool enviarAudio = false;

  @override
  void dispose() {
    _clean();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      focusNode.unfocus();
    });
    if (widget.chatId == 'newChat') {
      isFirst = true;
    }
    chatId = widget.chatId;

    handlePermissionsForCall(context);

    messageController.addListener(() {
      if (focusNode.hasFocus && messageController.text.isNotEmpty) {
        setTyping(true);
      } else if (!focusNode.hasFocus ||
          (focusNode.hasFocus && messageController.text.isEmpty)) {
        setTyping(false);
      }
    });

    iniciarTrack();
  }

  void iniciarTrack() {
    tempFile(suffix: '.aac').then((path) {
      recordingFile = path;
      track = Track(trackPath: recordingFile);
      init();
      setState(() {});
    });
  }

  Future<bool> init() async {
    if (!initialized) {
      await initializeDateFormatting();
      await UtilRecorder().init();
      ActiveCodec().recorderModule = UtilRecorder().recorderModule;
      ActiveCodec().setCodec(withUI: false, codec: Codec.aacADTS);

      initialized = true;
    }
    return initialized;
  }

  void _clean() async {
    if (recordingFile != null) {
      try {
        await File(recordingFile).delete();
      } on Exception {
        // ignore
      }
    }
  }

  setTyping(typing) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: false).user;
    Provider.of<ConversationViewModel>(context, listen: false)
        .setUserTyping(widget.chatId, user, typing);
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context, listen: true);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    return Consumer<ConversationViewModel>(
        builder: (BuildContext context, viewModel, Widget child) {
      return PickupLayout(
        scaffold: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_backspace,
              ),
            ),
            elevation: 0.0,
            titleSpacing: 0,
            title: buildUserName(),
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.videocam_circle_fill,
                    size: 30.0, color: Constants.gradianButtom),
                onPressed: () async {
                  var snapshotori = await usersRef.doc('${user.uid}').get();
                  UserModel userfrom = UserModel.fromJson(snapshotori.data());

                  var snapshot = await usersRef.doc('${widget.userId}').get();
                  UserModel userto = UserModel.fromJson(snapshot.data());

                  await handlePermissionsForCall(context)
                      ? CallUtils.dial(
                          from: userfrom,
                          to: userto,
                          typecall: "Video",
                          context: context)
                      : {};
                },
              ),
              // IconButton(
              //   icon: Icon(CupertinoIcons.phone_circle_fill,
              //       size: 30.0, color: Constants.gradianButtom),
              //   onPressed: () async {
              //     var snapshotori = await usersRef.doc('${user.uid}').get();
              //     UserModel userfrom = UserModel.fromJson(snapshotori.data());

              //     var snapshot = await usersRef.doc('${widget.userId}').get();
              //     UserModel userto = UserModel.fromJson(snapshot.data());

              //     await handlePermissionsForCall(context)
              //         ? CallUtils.dial(
              //             from: userfrom,
              //             to: userto,
              //             typecall: "Call",
              //             context: context)
              //         : {};
              //   },
              // ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  child: StreamBuilder(
                    stream: messageListStream(widget.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List messages = snapshot.data.docs;
                        viewModel.setReadCount(
                            widget.chatId, user, messages.length);
                        return ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            Message message = Message.fromJson(
                                messages.reversed.toList()[index].data());
                            Timer(Duration(seconds: 5), () async {
                              await viewModel.readMessage(chatId, user.uid);
                            });
                            return ChatBubble(
                              message: '${message.content}',
                              time: message?.time,
                              isMe: message?.senderUid == user?.uid,
                              type: message?.type,
                              read: message?.isRead,
                            );
                          },
                        );
                      } else {
                        return Center(child: circularProgress(context));
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10.0,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 100.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.photo_on_rectangle,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => showPhotoOptions(viewModel, user),
                          ),
                          Flexible(
                            child: TextField(
                              controller: messageController,
                              focusNode: focusNode,
                              style: TextStyle(
                                fontSize: 15.0,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: "Type your message",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Feather.mic,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => showAudioOptions(viewModel, user),
                          ),
                          IconButton(
                            icon: Icon(
                              Feather.send,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                sendMessage(viewModel, user);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildOnlineText(
    var user,
    bool typing,
  ) {
    if (user.isOnline) {
      if (typing) {
        return "typing...";
      } else {
        return "online";
      }
    } else {
      return 'last seen ${timeago.format(user.lastSeen.toDate())}';
    }
  }

  buildUserName() {
    return StreamBuilder(
      stream: usersRef.doc('${widget.userId}').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          UserModel user = UserModel.fromJson(documentSnapshot.data());
          return InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Hero(
                    tag: user.email,
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: CachedNetworkImageProvider(
                        '${user.photoUrl}',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.username}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      StreamBuilder(
                        stream: chatRef.doc('${widget.chatId}').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot snap = snapshot.data;
                            Map data = snap.data() ?? {};
                            Map usersTyping = data['typing'] ?? {};
                            return Text(
                              _buildOnlineText(
                                user,
                                usersTyping[widget.userId] ?? false,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  showPhotoOptions(ConversationViewModel viewModel, var user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Camera"),
              onTap: () {
                sendMessage(viewModel, user, imageType: 0, isImage: true);
              },
            ),
            ListTile(
              title: Text("Gallery"),
              onTap: () {
                sendMessage(viewModel, user, imageType: 1, isImage: true);
              },
            ),
          ],
        );
      },
    );
  }

  showAudioOptions(ConversationViewModel viewModel, var user) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildRecorder(track, viewModel, user),
          ],
        );
      },
    );
  }

  Widget _buildRecorder(
      Track track, ConversationViewModel viewModel, var user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RecorderPlaybackController(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Feather.x_circle,
                          size: 16.0,
                          color: Theme.of(context).accentColor,
                        ),
                        onTap: () {
                          UtilRecorder().reset();
                          enviarAudio = false;
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Recorder'),
                    ],
                  ),
                  if (enviarAudio)
                    GestureDetector(
                      child: Icon(
                        Feather.send,
                        size: 16.0,
                        color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        sendAudioMessage(viewModel, user);
                      },
                    )
                  else
                    Container(),
                ],
              ),
            ),
            SoundRecorderUI(
              track,
              onDelete: () {
                UtilRecorder().reset();
                this.setState(() {
                  enviarAudio = false;
                });
                Navigator.of(context).pop();
              },
              onStart: () {
                // print("Iniciando");
              },
              onPaused: (media, isPaused) async {
                // print("Pausada------>");
                var tamano = await makeBuffer(track.trackPath);
                if (tamano.length > 0 && isPaused) {
                  this.setState(() {
                    enviarAudio = true;
                    showAudioOptions(viewModel, user);
                  });
                }
              },
              onStopped: (media) async {
                // print("Paro------>");
                var tamano = await makeBuffer(track.trackPath);
                if (tamano.length > 0) {
                  this.setState(() {
                    enviarAudio = true;
                    showAudioOptions(viewModel, user);
                  });
                }
              },
            ),
            // Left('Recording Playback'),
            // SoundPlayerUI.fromTrack(
            //   track,
            //   enabled: false,
            //   showTitle: true,
            //   audioFocus: AudioFocus.requestFocusAndDuckOthers,
            // ),
          ],
        ),
      ),
    );
  }

  sendAudioMessage(ConversationViewModel viewModel, var user) async {
    String msg;
    msg = await viewModel.pickAudio(
      source: track.trackPath,
      context: context,
      chatId: widget.chatId,
    );

    Message message = Message(
      content: '$msg',
      senderUid: user?.uid,
      receiverUid: widget.userId,
      type: MessageType.AUDIO,
      time: Timestamp.now(),
      isRead: false,
      timeisRead: Timestamp.now(),
    );

    if (msg.isNotEmpty) {
      if (isFirst) {
        // print("FIRST");
        String id = await viewModel.sendFirstMessage(widget.userId, message);
        setState(() {
          isFirst = false;
          chatId = id;
        });
      } else {
        viewModel.sendMessage(
          widget.chatId,
          message,
        );
      }
      sendNotification(widget.chatId, widget.userId, message);
      UtilRecorder().reset();
      this.setState(() {
        enviarAudio = false;
      });
      Navigator.pop(context);
    }
  }

  sendMessage(ConversationViewModel viewModel, var user,
      {bool isImage = false, int imageType}) async {
    String msg;
    if (isImage) {
      msg = await viewModel.pickImage(
        source: imageType,
        context: context,
        chatId: widget.chatId,
      );
    } else {
      msg = messageController.text.trim();
      messageController.clear();
    }

    Message message = Message(
      content: '$msg',
      senderUid: user?.uid,
      receiverUid: widget.userId,
      type: isImage ? MessageType.IMAGE : MessageType.TEXT,
      time: Timestamp.now(),
      isRead: false,
      timeisRead: Timestamp.now(),
    );

    if (msg.isNotEmpty) {
      if (isFirst) {
        // print("FIRST");
        String id = await viewModel.sendFirstMessage(widget.userId, message);
        setState(() {
          isFirst = false;
          chatId = id;
        });
      } else {
        viewModel.sendMessage(
          widget.chatId,
          message,
        );
      }
      sendNotification(widget.chatId, widget.userId, message);
    }
  }

  void sendNotification(String chatid, String userId, Message message) async {
    //var documentSnapshot = await usersRef.doc(userId).get();

    //UserModel userdest = UserModel.fromJson(documentSnapshot.data());

    var map = {"chatId": chatid, "userId": userId};

    //if (!userdest.isOnline) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    var user = viewModel.user;
    viewModel.getToken(userId).then((value) async {
      if (value == null) return;
      var playerId = value;
      var imgUrlString = "";
      var contenido = "";
      if (message.type == MessageType.IMAGE) {
        imgUrlString = message.content;
        contenido = "Image";
      } else if (message.type == MessageType.TEXT) {
        contenido = message.content;
      } else if (message.type == MessageType.AUDIO) {
        contenido = "Auddio";
      } else if (message.type == MessageType.VIDEO) {
        contenido = "Video";
      }

      var notification = OSCreateNotification(
        playerIds: [playerId],
        content: contenido,
        // subtitle: "New message from " + user.displayName == null
        //     ? user.email
        //     : user.displayName,
        heading: "New message from " + user.displayName == ""
            ? user.email
            : user.displayName,
        //iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString == "" ? null : imgUrlString,
        androidSmallIcon: '@mipmap/launcher_icon',
        androidSound: 'assets/sounds/matrix-phone.mp3',
        additionalData: map,
        buttons: [
          OSActionButton(text: "Cancel", id: "id1"),
          OSActionButton(text: "Read", id: "id2")
        ],
      );

      await OneSignal.shared.postNotification(notification);

      // print("Sent notification with response: $response");
    });
    //}
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return chatRef
        .doc(documentId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}

///
class Left extends StatelessWidget {
  ///
  final String label;

  ///
  Left(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4, left: 8),
      child: Container(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
