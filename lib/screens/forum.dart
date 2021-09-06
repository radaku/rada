import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:radauon/components/chat.dart';
import 'package:radauon/model/chat_users.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final firestore = Firestore.instance.collection("Forum");
  // Event lastEvent;
  String lastConnectionState;
  Channel channel;
  @override
  void initState() {
    super.initState();
    // initPusher();
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init("f46cd4f7b5bf8ccbe238", PusherOptions(cluster: "ap2"),
          enableLogging: true);
    } catch (e) {
      //on PlatformException
      print(e.message);
    }
    await Pusher.connect(onConnectionStateChange: (res) {
      print("Current state is " + res.currentState);
    }, onError: (msg) {
      print(msg.message);
    });

    //subscribe
    channel = await Pusher.subscribe("chat");

    //bind
    channel.bind("chat_event", (msg) async {
      var convert = await json.decode(msg.data);
    });
  }

  List<ChatUsers> chatUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: GestureDetector(
          onTap: (){

            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 27,
          ),
        ),
      ):SizedBox(height: 0,width: 0,),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Forums",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .where("visibility", isEqualTo: "true")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: circularProgress(),
                      );
                    }
                    final int messageCount = snapshot.data.documents.length;

                    return ListView.builder(
                      itemCount: messageCount,
                      //shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document =
                            snapshot.data.documents[index];
                        final dynamic title = document['title'];
                        final dynamic image = document['image'];
                        final dynamic status = document['status'];
                        final dynamic slogan = document['slogan'];
                        print(title);
                        return document['visibility'] == "true"
                            ? ChatUsersList(
                                text: title,
                                secondaryText: status,
                                image: image,
                                time: "Now",
                                count: "3",
                                did: document.documentID,
                              )
                            : SizedBox();
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget counsellorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: circularProgress(),
          );
        final int messageCount = snapshot.data.documents.length;
        return Padding(
          padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
          child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (_, int index) {
              final DocumentSnapshot document = snapshot.data.documents[index];
              final dynamic title = document['title'];
              final dynamic image = document['image'];
              final dynamic status = document['status'];
              final dynamic slogan = document['slogan'];

              if (document['visibility'] == "true") {
                return forumCard(
                    title, image, status, document.documentID, slogan);
              }
              return SizedBox(
                height: 0,
                width: 0,
              );
            },
          ),
        );
      },
    );
  }*/

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
