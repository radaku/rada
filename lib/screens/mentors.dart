import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivityswift/connectivityswift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/mentorshiprequest.dart';
import 'package:radauon/screens/mentorshiproom.dart';

class Mentors extends StatefulWidget {
  String id;
  String name;
  String type;
  int count;

  Mentors({Key key, @required this.id, this.name, this.type, this.count});
  @override
  _MentorsState createState() => _MentorsState();
}

class _MentorsState extends State<Mentors> {
  final firestore = Firestore.instance.collection("Mentors");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid = [];

  int _counter = 0;

  bool _isMember = false;

  final List<Map> newsList = [];
  final List<Map> imgList = [];
  Map news;
  bool fetching = false;

  bool connected;

  bool getting = true;

  String message = "Fetching requests";

  void connection() async {
    var _connectivity = Connectivityswift();
    var connectivityResult = await _connectivity.checkConnectivity();
    // var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      connected = false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (newsList.length == 0) {
      getId();
    }
    connection();
    print(connected);
  }

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      if (newsList.length == 0) {
        getContacts(user.uid);
      }
      setState(() {
        useruid.add(user.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /*if (newsList.length == 0) {
      getId();
    }*/

    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: "Approved",
              ),
              Tab(
                text: "Requests",
              ),
            ],
          ),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          centerTitle: false,
          leading: Platform.isIOS?GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 27,
            ),
          ):GestureDetector(
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
            "Mentors",
            style: NeumorphicStyle(
              depth: 0, //customize depth here
              color: Colors.blue,
              shape: NeumorphicShape.convex, //customize color here
            ),
            textStyle: NeumorphicTextStyle(
                fontSize: 20, fontWeight: FontWeight.bold //customize size here
                // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
          ),
        ),
        //body: mentorsList(),
        body: TabBarView(
          /*children: [mentorsList(), requestsList()],*/
          children: [mentorsList(), requestsList()],
        ),
        floatingActionButton: FloatingActionButton(
          /*child: Icon(
            Icons.add,
            size: 27,
            color: Colors.white,
          ),*/
          child: Text(
            "Request",
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => MentorshipRequest()));
          },
        ),
      ),
    );
  }

  Widget requestsList() {
    /*return newsList.length == 0*/
    return newsList.length == 0
        ? Center(
            child: Text("No Items"),
          )
        : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: newsList.length,
            itemBuilder: (_, int index) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  index % 2 == 0
                      ? ListTile(
                          title: Text(
                            "Mentor: " + newsList[index]["type"],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            "Year of study: ${newsList[index]["year_of_study"]}\nStatus: Processing",
                            style:
                                TextStyle(color: Colors.black.withAlpha(170)),
                          ),
                        )
                      : ListTile(
                          title: Text(
                            "Mentor " + newsList[index]["type"],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            "Year of study: ${newsList[index]["year_of_study"]}\nStatus: Processing",
                            style:
                                TextStyle(color: Colors.black.withAlpha(170)),
                          ),
                        ),
                  Divider()
                ],
              );
            });
  }

  void getContacts(String uid) async {
    fetching = true;
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/mentorship/pending/$uid',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    if (convert.length == 0) {
      message = "No Requests";
    }
    setState(() {
      getting = false;
    });
    fetching = false;
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      if (news != null) {
        newsList.add(news);
      }
    }

    /*for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
    }*/
  }

  Widget mentorsList() {
    List<String> data = [];

    //print(useruid[0]);

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('myMentors')
            .document(useruid[0])
            .collection("mentors")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            final int messageCount = snapshot.data.documents.length;
            for (var i = 0; i < messageCount; i++) {
              data.add(snapshot.data.documents[i]["mentorid"]);
            }
          }

          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (!snap.hasData)
                    return Center(
                      child: circularProgress(),
                    );
                  final int mentorCount = snap.data.documents.length;
                  //print(data);
                  if (mentorCount > 0) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                      child: ListView.builder(
                        itemCount: snap.data.documents.length,
                        itemBuilder: (_, int index) {
                          final DocumentSnapshot document =
                              snap.data.documents[index];
                          final dynamic title = document['name'];
                          final dynamic image = document['image'];
                          final dynamic status = document['status'.toString()];
                          final dynamic mentees =
                              document['mentees'].toString();
                          final dynamic user_id =
                              document['user_id'].toString();

                          if (data.contains(user_id)) {
                            return mentorsCard(title, image, status,
                                document.documentID, mentees, document);
                          } else {
                            //print(data);
                          }

                          return SizedBox();

                          //return mentorsCard(title,image,status,document.documentID,mentees,document);
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Requests",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Raleway-regular'),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ));
        });
  }

  Widget mentorsCard(String title, String image, String status, String did,
      String mentees, DocumentSnapshot document) {
    bool member = false;
    return Card(
      //color: index%2==0?Colors.white:Colors.white,
      //color: Color(0xff195e83),
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 0, left: 0),
        child: GestureDetector(
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(5.0)),
              depth: 0,
              lightSource: LightSource.topLeft,
              color: Colors.grey[200],
            ),
            child: GestureDetector(
              onTap: mentorTap,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => MentorshipRoom(
                                id: document.documentID,
                                title: title,
                                image: image,
                                type: widget.type,
                              )));
                },
                isThreeLine: true,
                contentPadding: EdgeInsets.only(top: 0, right: 10),
                /*leading: Padding(padding: EdgeInsets.only(top: 10),child: Text(project.id.toString())),*/
                leading: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 0,
                          lightSource: LightSource.topLeft,
                          color: Colors.transparent),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        /*placeholder: (context, url) => Center(child: CircularProgressIndicator()),*/
                        placeholder: (context, url) =>
                            Center(child: circularProgress()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                ),
                title: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      title.length > 15
                          ? title.substring(0, 15) + "..."
                          : title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.brown),
                    )),
                subtitle: Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "$status\nAccepting $mentees more",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey[600]),
                    )),
                /*trailing: GestureDetector(onTap: (){_deleteRecord(index,projectSnap);},child: Icon(Icons.delete,color: Colors.redAccent,)),*/
                trailing: Icon(
                  Icons.more_vert,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void mentorTap() {
    print('Hello');
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
