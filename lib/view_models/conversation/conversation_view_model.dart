import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nine_levelv6/models/message.dart';
import 'package:nine_levelv6/services/chat_service.dart';
import 'package:nine_levelv6/utils/constants.dart';

class ConversationViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ChatService chatService = ChatService();
  bool uploadingImage = false;
  final picker = ImagePicker();
  File image;

  Future<String> searhMessage(String oriuserid, String destuserid) async {
    return await chatService.searhMessage(oriuserid, destuserid);
  }

  sendMessage(String chatId, Message message) {
    chatService.sendMessage(
      message,
      chatId,
    );
  }

  Future<String> sendFirstMessage(String recipient, Message message) async {
    String newChatId = await chatService.sendFirstMessage(
      message,
      recipient,
    );

    return newChatId;
  }

  readMessage(String chatId, String user) async {
    await chatService.readMessage(chatId, user);
  }

  setReadCount(String chatId, var user, int count) {
    chatService.setUserRead(chatId, user, count);
  }

  Future<int> getReadCount(String chatId, var user) async {
    return await chatService.getUserRead(chatId, user);
  }

  setUserTyping(String chatId, var user, bool typing) {
    chatService.setUserTyping(chatId, user, typing);
  }

  pickImage({int source, BuildContext context, String chatId}) async {
    File image = source == 0
        ? await ImagePicker.pickImage(
            source: ImageSource.camera,
          )
        : await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );

    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Constants.darkAccent,
          toolbarWidgetColor: Theme.of(context).iconTheme.color,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      Navigator.of(context).pop();

      if (croppedFile != null) {
        uploadingImage = true;
        image = croppedFile;
        notifyListeners();
        showInSnackBar("Uploading image...");
        String imageUrl = await chatService.uploadImage(croppedFile, chatId);
        return imageUrl;
      }
    }
  }

  pickAudio({String source, BuildContext context, String chatId}) async {
    File audio;

    Navigator.of(context).pop();

    if (source != null) {
      audio = File(source);
      uploadingImage = true;
      notifyListeners();
      showInSnackBar("Uploading Audio...");
      String imageUrl = await chatService.uploadAudio(audio, chatId);
      return imageUrl;
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
