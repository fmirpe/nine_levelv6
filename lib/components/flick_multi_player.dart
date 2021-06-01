import 'package:nine_levelv6/components/portrait_controls.dart';
import 'package:nine_levelv6/components/thumbnail_generator.dart';
import 'package:nine_levelv6/widgets/indicators.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';

import './flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class FlickMultiPlayer extends StatefulWidget {
  const FlickMultiPlayer({
    Key key,
    @required this.url,
    @required this.flickMultiManager,
    this.thumbnail,
    this.mute = false,
  }) : super(key: key);

  final String url;
  final FlickMultiManager flickMultiManager;
  final String thumbnail;
  final bool mute;

  @override
  _FlickMultiPlayerState createState() => _FlickMultiPlayerState();
}

class _FlickMultiPlayerState extends State<FlickMultiPlayer> {
  FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url)
        ..setLooping(true),
      autoPlay: false,
    );
    widget.flickMultiManager.init(flickManager);
    if (widget.mute == true) {
      widget.flickMultiManager.toggleMute();
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.flickMultiManager.remove(flickManager);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visiblityInfo) {
        if (visiblityInfo.visibleFraction > 0.85) {
          widget.flickMultiManager.play(flickManager);
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            playerLoadingFallback: Positioned.fill(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: widget.thumbnail != null
                        ? Image.network(widget.thumbnail)
                        : ThumbnailGenerator(
                            thumbnailRequest: ThumbnailRequest(
                              video: widget.url,
                              thumbnailPath: null,
                              imageFormat: ImageFormat.JPEG,
                              maxHeight: 400,
                              maxWidth: 500,
                              timeMs: 0,
                              quality: 100,
                            ),
                          ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      child: circularProgress(context),
                    ),
                  ),
                ],
              ),
            ),
            controls: FeedPlayerPortraitControls(
              flickMultiManager: widget.flickMultiManager,
              flickManager: flickManager,
            ),
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            playerLoadingFallback: Center(
              child: widget.thumbnail != null
                  ? Image.network(widget.thumbnail)
                  : ThumbnailGenerator(
                      thumbnailRequest: ThumbnailRequest(
                        video: widget.url,
                        thumbnailPath: null,
                        imageFormat: ImageFormat.JPEG,
                        maxHeight: 400,
                        maxWidth: 500,
                        timeMs: 0,
                        quality: 100,
                      ),
                    ),
            ),
            controls: FlickLandscapeControls(),
            iconThemeData: IconThemeData(
              size: 40,
              color: Colors.white,
            ),
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
