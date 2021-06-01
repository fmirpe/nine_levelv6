import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:nine_levelv6/utils/file_utils.dart';
import 'package:nine_levelv6/utils/firebase.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

abstract class Service {
  Future<String> uploadImage(Reference ref, File file) async {
    var targetPath = "";
    // var result = await FlutterImageCompress.compressAndGetFile(
    //   file.absolute.path,
    //   targetPath,
    //   quality: 95,
    // );

    String ext = FileUtils.getFileExtension(file);
    Reference storageReference = ref.child("${uuid.v4()}.$ext");
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    String fileUrl = await storageReference.getDownloadURL();
    return fileUrl;
  }

  Future<String> uploadVideo(Reference ref, File file) async {
    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
      includeAudio: true,
    );

    String ext = FileUtils.getFileExtension(file);
    Reference storageReference = ref.child("${uuid.v4()}.mp4");
    UploadTask uploadTask = storageReference.putFile(mediaInfo.file);
    await uploadTask.whenComplete(() => null);
    String fileUrl = await storageReference.getDownloadURL();
    return fileUrl;
  }
}
