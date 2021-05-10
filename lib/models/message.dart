import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nine_levelv6/models/enum/message_type.dart';

class Message {
  String content;
  String senderUid;
  MessageType type;
  Timestamp time;
  bool isRead;
  Timestamp timeisRead;

  Message({
    this.content,
    this.senderUid,
    this.type,
    this.time,
    this.isRead,
    this.timeisRead,
  });

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    senderUid = json['senderUid'];
    if (json['type'] == 'text') {
      type = MessageType.TEXT;
    } else {
      type = MessageType.IMAGE;
    }
    time = json['time'];
    isRead = json['isRead'];
    timeisRead = json['timeisRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['senderUid'] = this.senderUid;
    if (this.type == MessageType.TEXT) {
      data['type'] = 'text';
    } else {
      data['type'] = 'image';
    }
    data['time'] = this.time;
    data['isRead'] = this.isRead;
    data['timeisRead'] = this.timeisRead;
    return data;
  }
}
