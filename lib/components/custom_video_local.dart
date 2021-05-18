import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVideoLocal extends StatefulWidget {
  final File imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  CustomVideoLocal({
    this.imageUrl,
    this.height = 100.0,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  @override
  _CustomVideoLocalState createState() => _CustomVideoLocalState();
}

class _CustomVideoLocalState extends State<CustomVideoLocal> {
  FlickManager flickManager;
  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.imageUrl),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      child: VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            flickManager.flickControlManager?.autoPause();
          } else if (visibility.visibleFraction == 1) {
            flickManager.flickControlManager?.autoResume();
          }
        },
        child: Container(
          child: FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              controls: FlickLandscapeControls(),
            ),
          ),
        ),
      ),
    );
  }
}
