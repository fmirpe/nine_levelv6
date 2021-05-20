import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/components/flick_multi_manager.dart';
import 'package:nine_levelv6/models/post.dart';
import 'package:nine_levelv6/screens/view_image.dart';
import 'package:nine_levelv6/screens/view_video.dart';
import 'package:nine_levelv6/widgets/cached_image.dart';
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';

class PostTile extends StatefulWidget {
  final PostModel post;

  PostTile({this.post});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  FlickMultiManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = new FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => widget.post.type == 1
              ? ViewImage(post: widget.post)
              : ViewVideo(post: widget.post),
        ));
      },
      child: Container(
        height: 100,
        width: 150,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            child: widget.post.type == 1
                ? cachedNetworkImage(widget.post.mediaUrl)
                : ThumbnailImage(
                    videoUrl: widget.post.mediaUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
