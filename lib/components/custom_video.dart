import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/components/flick_multi_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'flick_multi_manager.dart';

class CustomVideo extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  CustomVideo({
    this.imageUrl,
    this.height = 100.0,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  @override
  _CustomVideoState createState() => _CustomVideoState();
}

class _CustomVideoState extends State<CustomVideo> {
  FlickMultiManager flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = new FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: VisibilityDetector(
          key: ObjectKey(flickManager),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction == 0 && this.mounted) {
              flickManager.pause();
            }
          },
          child: FlickMultiPlayer(
            url: widget.imageUrl,
            flickMultiManager: flickManager,
            mute: true,
          ),
        ),
      ),
    );
  }
}
