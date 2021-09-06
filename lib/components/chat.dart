import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/model/forummodel.dart';
import 'package:radauon/rooms/forumroom.dart';
import 'package:radauon/utils/forum_helper.dart';

class ChatUsersList extends StatefulWidget {
  String text;
  String secondaryText;
  String image;
  String time;
  String count;
  String did;
  ChatUsersList({
    @required this.text,
    @required this.secondaryText,
    @required this.image,
    @required this.time,
    @required this.count,
    @required this.did,
  });
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  ForumHelper _forumHelper;

  List<String> msgList = [];
  List<String> count_list = [];

  bool _show = false;

  void getCount() async {
    List<ForumModel> recs = await _forumHelper.getMessages();
    print(recs[recs.length - 1].time);
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/count/${recs[recs.length - 1].time}',
        /*'http://192.168.8.103/LaravelPusher/public/count/${1603282843642}',*/

        headers: {"Accept": "application/json"});

    var converted = await json.decode(response.body);

    setState(() {
      for (var i = 0; i < converted.length; i++) {
        msgList.add(converted[i]);
      }
    });
    print("The data is: " + converted.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _forumHelper = ForumHelper();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ForumRoom(
                id: widget.did,
                title: widget.text,
                image: widget.image,
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 57,
                        width: 57,
                        child: Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 0,
                              lightSource: LightSource.topLeft,
                              color: Colors.grey[200]),
                          child: CachedNetworkImage(
                            imageUrl: widget.image,
                            /*placeholder: (context, url) => Center(child: CircularProgressIndicator()),*/
                            placeholder: (context, url) =>
                                Center(child: circularProgress()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.text,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.secondaryText,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                msgList.contains(widget.did)
                    /*? Badge(
                        badgeContent: Padding(
                          padding: EdgeInsets.all(5),
                          */ /*child: Icon(CupertinoIcons.bell),*/ /*
                          child: Text(
                            filter(widget.did),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        badgeColor: Colors.green[400],
                        elevation: 0,
                      )
                    : SizedBox()*/
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 3,
                          width: 3,
                          color: Colors.green,
                        ))
                    : SizedBox()
                //Text(msgList.toString())
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 87), child: Divider())
      ],
    );
  }

  String filter(String id) {
    for (var i = 0; i < msgList.length; i++) {
      if (msgList[i] == id) {
        count_list.add(msgList[i]);
      }
    }

    if (count_list.length > 0) {
      setState(() {
        _show = true;
      });
    }

    return count_list.length.toString();
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
