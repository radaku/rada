import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:link_text/link_text.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Map notif;
  List<Map> notifList = [];
  List<Map> msgList = [];

  void getNews() async {
    print('Fetching notifications...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/notifications/get',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      notif = convert[i];
      setState(() {
        notifList.add(notif);
      });
    }

    for (var i = 0; i < notifList.length; i++) {
      /*imgList.add(
        {"title":data[i]["title"],"image":data[i]["image"],"content":data[i]["news"]}
      );*/
      msgList.add(notifList[i]);
    }
    print(msgList);

    //print(newsList[0]["title"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  Widget circularProgress() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.white),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: Platform.isIOS?AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 27,
              ),
            ),

            title: NeumorphicText(
              "Notifications",
              style: NeumorphicStyle(
                depth: 0, //customize depth here
                color: Colors.blue,
                shape: NeumorphicShape.convex, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                  ),
            ),
          ):AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 27,
              ),
            ),

            title: NeumorphicText(
              "Notifications",
              style: NeumorphicStyle(
                depth: 0, //customize depth here
                color: Colors.blue,
                shape: NeumorphicShape.convex, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold //customize size here
                // AND others usual text style properties (fontFamily, fontWeight, ...)
              ),
            ),
          ),
          body: ListView.builder(
              itemCount: msgList.length,
              scrollDirection: Axis.vertical,
              reverse: true,
              itemBuilder: (context, index) {
                if (msgList[index]["type"] == "Link with image") {
                  //return Text(msgList[index]["title"].toString());

                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2, right: 2, top: 20, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.network(
                                          msgList[index]["image"],
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                          constraints: new BoxConstraints(
                                            minHeight: 20.0,
                                            maxHeight: 60.0,
                                          ),
                                          //height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white.withAlpha(150),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 2,
                                                right: 50,
                                                left: 5,
                                                bottom: 2),
                                            child: Wrap(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 2,
                                                      right: 5,
                                                      left: 5,
                                                      bottom: 2),
                                                  child: Text(
                                                    msgList[index]["title"],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily:
                                                            'Raleway-regular',
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 50,
                                  width: 2,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.blueAccent.withAlpha(60),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8,
                                          top: 4,
                                          right: 8,
                                          bottom: 10),
                                      child: LinkText(
                                        text: msgList[index]["link"],
                                        textAlign: TextAlign.center,
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                        ),
                                        linkStyle: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (msgList[index]["type"] == "Link with text") {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3, right: 3, top: 20, bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey[800],
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 3, right: 3),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, top: 4, right: 8, bottom: 0),
                                      child: Text(
                                        msgList[index]["title"],
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, top: 4, right: 8, bottom: 0),
                                      child: Text(
                                        msgList[index]["message"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, top: 4, right: 8, bottom: 0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                top: 4,
                                                right: 8,
                                                bottom: 4),
                                            child: LinkText(
                                              text: msgList[index]["link"],
                                              textAlign: TextAlign.center,
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                              linkStyle: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                  //return Text(msgList[index]["title"].toString());
                } else if (msgList[index]["type"] == "Link") {
                  //return Text(msgList[index]["title"].toString());
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3, right: 3, top: 20, bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blueAccent.withAlpha(40),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 3, right: 3),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, top: 4, right: 8, bottom: 0),
                                      child: Text(
                                        msgList[index]["title"],
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, top: 4, right: 8, bottom: 0),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                top: 4,
                                                right: 8,
                                                bottom: 4),
                                            child: LinkText(
                                              text: msgList[index]["link"],
                                              textAlign: TextAlign.center,
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                              linkStyle: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (msgList[index]["type"] == "Text with image") {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2, right: 2, bottom: 10, top: 20),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(0)),
                                            child: Image.network(
                                              msgList[index]["image"],
                                              fit: BoxFit.cover,
                                            ))),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                          constraints: new BoxConstraints(
                                            minHeight: 20.0,
                                            maxHeight: 60.0,
                                          ),
                                          //height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white.withAlpha(200),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 2,
                                                right: 50,
                                                left: 5,
                                                bottom: 2),
                                            child: Wrap(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 2,
                                                      right: 5,
                                                      left: 5,
                                                      bottom: 2),
                                                  child: Text(
                                                    msgList[index]["title"],
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily:
                                                            'Raleway-regular',
                                                        fontSize: 19),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          _shareText(msgList[index]["message"]);
                                        },
                                        child: Icon(
                                          Icons.share,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.grey[300],
                                color: Colors.blueAccent.withAlpha(40),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 4, right: 8, bottom: 4),
                                  child: Text(
                                    msgList[index]["message"],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              })),
    );
  }

  Future<void> _shareText(String text) async {
    try {
      Share.text('Share to', text, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageFromUrl(String url) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Share to', 'amlog.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
  }
}
