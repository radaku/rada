import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';

class ArticlePage extends StatefulWidget {
  String title;
  String image;
  String content;

  ArticlePage({Key key, @required this.title, this.image, this.content})
      : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[100],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 27,
          ),
        ),
        title: Text(
          "News Article",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ):AppBar(
        backgroundColor: Colors.grey[100],
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 27,
          ),
        ),
        title: Text(
          "News Article",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                      imageUrl: widget.image,
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
                          )),
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              //color: Color(0xff1979a9).withAlpha(100),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 200,
            left: 5,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                //color: Colors.grey.withAlpha(200),
                color: Colors.white,
                height: 370,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 19,
                              //fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        )),
                    Divider(),
                    //SizedBox(height: 10,),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        /*child: Text(
                          widget.content,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1
                          ),
                        )),*/
                        child: ReadMoreText(
                          widget.content,
                          trimLines: 16,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...read more',
                          trimExpandedText: ' show less',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        )),
                  ],
                ),
              ),
            ),
          )

          /*Text(widget.title),
            SizedBox(height: 5,),
            Text(widget.content)*/
        ],
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
}
