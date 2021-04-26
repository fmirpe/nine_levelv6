import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/widgets/indicators.dart';
import 'package:video_player/video_player.dart';

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
  @override
  Widget build(BuildContext context) {
    VideoPlayerController _controller;

    @override
    void initState() {
      super.initState();
      _controller = VideoPlayerController.network(widget.imageUrl);

      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}
