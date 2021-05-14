import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/components/text_time.dart';
import 'package:nine_levelv6/models/enum/message_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatefulWidget {
  final String message;
  final MessageType type;
  final Timestamp time;
  final bool isMe;
  final bool read;

  ChatBubble({
    @required this.message,
    @required this.time,
    @required this.isMe,
    @required this.type,
    @required this.read,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Color chatBubbleColor() {
    if (widget.isMe) {
      return Theme.of(context).accentColor;
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.grey[200];
      }
    }
  }

  Color chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600];
    } else {
      return Colors.grey[50];
    }
  }

  @override
  Widget build(BuildContext context) {
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final calign =
        widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius = widget.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: chatBubbleColor(),
            borderRadius: radius,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
            minWidth: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.all(widget.type == MessageType.TEXT ? 5 : 0),
                child: widget.type == MessageType.TEXT
                    ? Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.isMe
                              ? Colors.white
                              : Theme.of(context).textTheme.headline6.color,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: "${widget.message}",
                        maxWidthDiskCache: 200,
                        //height: 200,
                        width: MediaQuery.of(context).size.width / 1.3,
                        fit: BoxFit.contain,
                      ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: calign,
          children: [
            TextTime(
              child: Text(
                timeago.format(widget.time.toDate()),
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                  fontSize: 10.0,
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            widget.isMe
                ? !widget.read
                    ? Icon(
                        Icons.check,
                        size: 10,
                      )
                    : Icon(
                        Icons.done_all,
                        size: 10,
                      )
                : Container(),
          ],
        ),
      ],
    );
  }
}
