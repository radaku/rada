import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radauon/rooms/roomtwo.dart';

class Counsellors extends StatefulWidget {
  String myid;

  Counsellors({
    Key key,
    @required this.myid,
  }) : super(key: key);

  @override
  _CounsellorsState createState() => _CounsellorsState();
}

class _CounsellorsState extends State<Counsellors> {
  List useruid = [];

  final firestore = Firestore.instance.collection("Counsellors");
  final counsellorrooms = Firestore.instance.collection("Rooms");
  final counter = Firestore.instance.collection("CounsellorsCounter");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool show = false;

  List list = [];

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        useruid.add(user.uid);
      });
    });
  }

  Map counts = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getId();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getId();
    });
    return Scaffold(
      backgroundColor: Color(0xff1979a9),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: Platform.isIOS?AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: "Conversations"),
                Tab(
                  text: "Counsellors",
                ),
              ],
            ),
            title: NeumorphicText(
              "Rada Counselling",
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
            centerTitle: true,
            elevation: 0,
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
          ):AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: "Conversations"),
                Tab(
                  text: "Counsellors",
                ),
              ],
            ),
            title: NeumorphicText(
              "Rada Counselling",
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
            centerTitle: true,
            elevation: 0,
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
          ),
          body: TabBarView(
            children: [
              roomsList(),
              counsellorsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget roomsList() {
    /* return StreamBuilder<QuerySnapshot>(
      stream: counter.document().snapshots(),

    );*/

    return StreamBuilder<QuerySnapshot>(
      stream: counsellorrooms.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: circularProgress(),
          );
        final int messageCount = snapshot.data.documents.length;
        /*print(snapshot.data);*/
        if (messageCount < 1) {
          return Center(
            child: Text(
              "No Conversations",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontFamily: 'Raleway-regular'),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: messageCount,
                itemBuilder: (_, int index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];

                  //baaad code
                  if (document["student"] == useruid[0]) {
                    return Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, right: 0, left: 0),
                        child: GestureDetector(
                          onTap: () {
                            //print(did);
                          },
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(0.0)),
                              depth: 0,
                              lightSource: LightSource.topLeft,
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => RoomTwo(
                                                id: document.documentID,
                                                name:
                                                    document["counsellor_name"],
                                                image: document[
                                                    "counsellor_image"],
                                                status: document[
                                                    "counsellor_status"],
                                                counsellorid:
                                                    document["counsellor"],
                                                studentid:
                                                    document["student"])));
                                  },
                                  isThreeLine: true,
                                  contentPadding:
                                      EdgeInsets.only(top: 0, right: 10),
                                  leading: Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            boxShape:
                                                NeumorphicBoxShape.circle(),
                                            depth: 0,
                                            lightSource: LightSource.topLeft,
                                            color: Colors.transparent),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              document["counsellor_image"],
                                          placeholder: (context, url) =>
                                              Center(child: circularProgress()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
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
                                  /*trailing: Badge(
                                    badgeContent: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        )),
                                    badgeColor: Colors.blue.withAlpha(70),
                                    elevation: 0,
                                  ),*/
                                  title: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        document["counsellor_name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff131D56)),
                                      )),
                                  /*subtitle: Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      "Campus: " +
                                          document["counsellor_campus"].toString() +
                                          "\n${document["counsellor_status"].toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    )),*/
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            Theme.of(context).textTheme.body1,
                                        children: [
                                          TextSpan(
                                              text:
                                                  'Campus: ${document["counsellor_campus"].toString()}\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54)),
                                          /*WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                            child: Icon(Icons.star,size: 18,color: Colors.amber,),
                                          ),
                                        ),*/
                                          TextSpan(
                                              text:
                                                  /*'${document["counsellor_status"].toString()}',*/
                                                  'Hello there, say  something to me.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green[400]))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (document["counsellor"] == useruid[0]) {
                    return Card(
                      //color: index%2==0?Colors.white:Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, right: 0, left: 0),
                        child: GestureDetector(
                          onTap: () {
                            //print(did);
                          },
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(0.0)),
                              depth: 2,
                              lightSource: LightSource.topLeft,
                              color: Colors.white,
                            ),
                            child: ListTile(
                              onTap: () {
                                //print(document.documentID);
                                //print(document.documentID);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => RoomTwo(
                                            id: document.documentID,
                                            name: document["student_name"],
                                            image: document["student_image"],
                                            status: document["student_status"],
                                            counsellorid:
                                                document["counsellor"],
                                            studentid: document["student"])));
                              },
                              isThreeLine: true,
                              contentPadding:
                                  EdgeInsets.only(top: 0, right: 10),
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
                                        depth: 8,
                                        lightSource: LightSource.topLeft,
                                        color: Colors.transparent),
                                    child: CachedNetworkImage(
                                      imageUrl: document["student_image"],
                                      placeholder: (context, url) =>
                                          Center(child: circularProgress()),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
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
                                    document["student_name"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                              subtitle: Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      "Campus: " +
                                          document["student_campus"]
                                              .toString() +
                                          "\n${document["student_status"].toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54))),
                              /*trailing: GestureDetector(onTap: (){_deleteRecord(index,projectSnap);},child: Icon(Icons.delete,color: Colors.redAccent,)),*/
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  //baaad code ends here

                  document["student"] == useruid[0]
                      ? Text(document["counsellor_name"])
                      : Text(document["student_name"]);

                  return SizedBox(
                    height: 0,
                    width: 0,
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget counsellorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .where("visible", isEqualTo: true)
          //.orderBy("created_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: circularProgress(),
          );
        
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (_, int index) {
              final DocumentSnapshot document = snapshot.data.documents[index];
              final dynamic name = document['name'];
              final dynamic expertise = document['expertise'];
              final dynamic rating = double.parse(document['rating'])
                  .toStringAsFixed(1)
                  .toString();
              final dynamic image = document['image'];
              final dynamic status = document['status'];

              if (document.documentID != useruid[0] &&
                  document['visible'] == true) {
                return counsellorCard(name, image, expertise, status, rating,
                    document.documentID, useruid[0]);
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
  }

  Widget counsellorCard(String name, String image, String expertise,
      String status, String rating, String did, String student) {
    return Card(
      //color: index%2==0?Colors.white:Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 0, left: 0),
        child: GestureDetector(
          onTap: () {
            print("hello");
          },
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(0.0)),
                depth: 0,
                lightSource: LightSource.topLeft,
                color: Colors.white),
            child: ListTile(
              onTap: () {
                //print(document.documentID);
                Firestore.instance
                    .collection('Rooms')
                    .getDocuments()
                    .then((value) {
                  List m = [];
                  value.documents.forEach((element) {
                    m.add(element.documentID.toString());
                  });
                  if (m.contains(did + useruid[0]) ||
                      m.contains(useruid[0] + did)) {
                    Flushbar(
                      title: "View In Conversations",
                      message: "Already in your conversations",
                      backgroundColor: Colors.blue,
                      icon: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                      duration: Duration(seconds: 3),
                      isDismissible: false,
                    )..show(context);
                  } else {
                    setState(() {
                      show = true;
                    });

                    var roomsReference = Firestore.instance
                        .collection('Rooms')
                        .document(did + useruid[0]);

                    Firestore.instance
                        .collection("Users")
                        .document(useruid[0])
                        .get()
                        .then((student) {
                      Firestore.instance
                          .collection("Users")
                          .document(did)
                          .get()
                          .then((counsellor) {
                        Firestore.instance.runTransaction((transaction) async {
                          await transaction.set(
                            roomsReference,
                            {
                              'student': useruid[0],
                              'counsellor': did,
                              'student_name': student.data["name"],
                              'student_image': student.data["image"],
                              'student_status': student.data["status"],
                              'student_campus': student.data["campus"],
                              'counsellor_name': counsellor.data["name"],
                              'counsellor_image': counsellor.data["image"],
                              'counsellor_status': counsellor.data["status"],
                              'counsellor_campus': counsellor.data["campus"],
                            },
                          );
                        }).then((value) {
                          setState(() {
                            show = false;
                            /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => RoomTwo(
                                            id: did,
                                            name: name,
                                            image: image,
                                            status: status,
                                            counsellorid: did,
                                            studentid: student,
                                          )));*/
                            Flushbar(
                              title: "Success",
                              message: "Counsellor Added To Your Conversations",
                              backgroundColor: Colors.green,
                              icon: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                              duration: Duration(seconds: 3),
                              isDismissible: false,
                            )..show(context);
                          });
                        });
                      });
                    });

                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>RoomTwo(id: did,name: name,image: image,status: status,counsellorid:did,studentid: useruid[0],)));
                  }
                });
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>CounselingRoom(id: did,name: name,image: image,status: status,)));
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
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xff131D56)),
                  )),
              subtitle: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: [
                      TextSpan(
                          text: 'Expertise: ${expertise.toString()}\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                      /*WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Icon(Icons.star,size: 18,color: Colors.amber,),
                            ),
                          ),*/
                      TextSpan(
                          text: 'Rating: ${rating.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*trailing: Text(
                  status,
                  style: TextStyle(
                      color: Colors.green[400], fontWeight: FontWeight.bold),
                )*/
            ),
          ),
        ),
      ),
    );
  }

  Widget roomsCard(String name, String image, String campus, String status,
      String did, String cid) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 0, left: 0),
        child: GestureDetector(
          onTap: () {
            //print(did);
          },
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(0.0)),
              depth: 0,
              lightSource: LightSource.topLeft,
              color: Colors.white,
            ),
            child: ListTile(
              onTap: () {
                //print(document.documentID);
                //print(did);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => RoomTwo(
                            id: did,
                            name: name,
                            image: image,
                            status: status,
                            counsellorid: cid)));
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
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        color: Colors.transparent),
                    child: CachedNetworkImage(
                      imageUrl: image,
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
                    name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
              subtitle: Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Campus: " + campus.toString() + "\n${status.toString()}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  )),
              /*trailing: GestureDetector(onTap: (){_deleteRecord(index,projectSnap);},child: Icon(Icons.delete,color: Colors.redAccent,)),*/
            ),
          ),
        ),
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

    //SpinKitThreeBounce
  }
}
