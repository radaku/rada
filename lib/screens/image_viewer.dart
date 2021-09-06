import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:video_player/video_player.dart';

/*final videoPlayerController = VideoPlayerController.network(
    'https://mysitemose.000webhostapp.com/uploads/1601466466.mp4');*/

class ImageView extends StatefulWidget {
  String url;
  String type;

  ImageView({
    Key key,
    @required this.url,
    this.type,
  }) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  String _platformVersion = 'Unknown';
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text("Media Viewer"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
      ):AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text("Media Viewer"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Center(
        child: Container(
            height: 320,
            width: MediaQuery.of(context).size.width,
            child: widget.type == "image"
                ? CachedNetworkImage(
                    imageUrl: widget.url.trim(),
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.colorBurn,
                              ),
                            ),
                          ),
                        ),
                    placeholder: (context, url) =>
                        Center(child: circularProgress()),
                    errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error,
                            size: 40,
                          ),
                        ))
                : Container(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  )),
      ),
    );
  }

  Widget circularProgress() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.blueAccent),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.url.trim());
    _videoPlayerController2 = VideoPlayerController.network(widget.url.trim());
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 10 / 10,
        autoPlay: true,
        looping: false,
        showControls: true);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GalleryView.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
}
