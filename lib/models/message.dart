import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nine_levelv6/models/enum/message_type.dart';

class Message {
  String content;
  String senderUid;
  String receiverUid;
  MessageType type;
  Timestamp time;
  bool isRead;
  Timestamp timeisRead;

  Message({
    this.content,
    this.senderUid,
    this.receiverUid,
    this.type,
    this.time,
    this.isRead,
    this.timeisRead,
  });

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    senderUid = json['senderUid'];
    receiverUid = json['receiverUid'];
    if (json['type'] == 'text') {
      type = MessageType.TEXT;
    } else if (json['type'] == 'image') {
      type = MessageType.IMAGE;
    } else if (json['type'] == 'audio') {
      type = MessageType.AUDIO;
    } else if (json['type'] == 'video') {
      type = MessageType.VIDEO;
    } else {
      type = MessageType.TEXT;
    }
    time = json['time'];
    isRead = json['isRead'];
    timeisRead = json['timeisRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['senderUid'] = this.senderUid;
    data['receiverUid'] = this.receiverUid;
    if (this.type == MessageType.TEXT) {
      data['type'] = 'text';
    } else if (this.type == MessageType.IMAGE) {
      data['type'] = 'image';
    } else if (this.type == MessageType.AUDIO) {
      data['type'] = 'audio';
    } else if (this.type == MessageType.VIDEO) {
      data['type'] = 'video';
    } else {
      data['type'] = 'text';
    }
    data['time'] = this.time;
    data['isRead'] = this.isRead;
    data['timeisRead'] = this.timeisRead;
    return data;
  }
}
