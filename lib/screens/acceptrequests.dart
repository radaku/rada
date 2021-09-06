import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../themes.dart';

class AcceptRequests extends StatefulWidget {
  @override
  _AcceptRequestsState createState() => _AcceptRequestsState();
}

class _AcceptRequestsState extends State<AcceptRequests> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid=[];
  final firestore=Firestore.instance.collection("Mentors");

  bool show=false;
  bool showred=false;



  @override
  void initState() {
    super.initState();


    setState(() {
      getId();
    });
  }

  void getId() async{
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        useruid.add(user.uid);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      getId();
    });
    return Scaffold(
      backgroundColor: Color(0xff1979a9),
      appBar: Platform.isIOS?AppBar(
        elevation: 0,
        centerTitle: true,
        title: NeumorphicText(
          "Mentorship Requests",
          style: NeumorphicStyle(
            depth: 0,  //customize depth here
            color: Colors.white,
            shape: NeumorphicShape.convex,//customize color here
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 20, //customize size here
            // AND others usual text style properties (fontFamily, fontWeight, ...)
          ),
        ),
        leading: Icon(Icons.arrow_back_ios,color: Colors.white,size: 27,),
        backgroundColor: Color(0xff1979a9),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.white,)),
        ],
      ):AppBar(
        elevation: 0,
        centerTitle: true,
        title: NeumorphicText(
          "Mentorship Requests",
          style: NeumorphicStyle(
            depth: 0,  //customize depth here
            color: Colors.white,
            shape: NeumorphicShape.convex,//customize color here
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 20, //customize size here
            // AND others usual text style properties (fontFamily, fontWeight, ...)
          ),
        ),
        leading: Icon(Icons.arrow_back,color: Colors.white,size: 27,),
        backgroundColor: Color(0xff1979a9),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.white,)),
        ],
      ),
      body: requetsList()
    );
  }

  Widget requestCard(String name,String image, String email, String phone, String campus,String requester){
    return Padding(
      padding:EdgeInsets.only(left: 5,right: 5,top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5.0,
                right: 70.0,
                width: 120.0,
                child: Container(
                  height: 0.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/settings.png'),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 7.0, bottom: 0.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style: boldBlackLargeTextStyle,
                            ),
                            Text(
                              campus,
                              style: boldBlackLargeTextStyle,
                            ),
                          ],
                        ),
                        Spacer(),
                        /*ClipOval(
                          child: Image.asset(
                            'assets/images/ball.jpg',
                            fit: BoxFit.cover,
                            height: 60.0,
                            width: 60.0,
                          ),
                        ),*/
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 60,
                            width: 60,
                            child: CachedNetworkImage(
                              height: 60,
                              width: 60,
                              imageUrl: image,
                              placeholder: (context, url) => Center(child: circularProgress()),
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
                            /*child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              height: 60.0,
                              width: 60.0,
                            ),*/
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              email,
                              style: boldBlackLargeTextStyle,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  phone,
                                  style: boldBlackLargeTextStyle,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "Pending",
                          style: boldPurpleTextStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(height: 2,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        showred==false?FlatButton(
                          onPressed: (){
                            deleteRequest(requester);
                          },
                          child: Text(
                            "Reject",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                          ),
                        ):redProgress(),
                        show==false?FlatButton(
                          onPressed: (){
                            deleteRequestReplace(requester,name,email,image,phone,campus);
                          },
                          child: Text("Accept",style: TextStyle(color: Colors.green[400],fontWeight: FontWeight.bold),),
                        ):circularProgress(),
                      ],
                    )
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteRequest(String requester){
    showred=true;
    var dref=Firestore.instance.collection("Mentors").document(useruid[0]);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(
        dref.collection("requests").document(requester),
      );
    }).then((value){
      setState(() {
        showred=false;
      });
    });
  }

  void deleteRequestReplace(String requester,String name,String email,String image,String phone,String campus){
    show=true;
    var dref=Firestore.instance.collection("Mentors").document(useruid[0]);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(
        dref.collection("requests").document(requester),
      );
    }).then((value){

      Firestore.instance.collection("Users").document(useruid[0]).get().then((user){
        Firestore.instance.collection("DeviceTokens").document(requester).get().then((devi){
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              dref.collection("members").document(requester),
              {
                'name': name,
                'image': image,
                'phone':phone,
                'email':email,
                'campus':campus,
                'mentor':user.data['name'],
                'device':devi.data["device"],
                'created_at':DateTime.now()

              },
            );
          }).then((value){
            Flushbar(
              title: "Success",
              message: name+" is now a member",
              backgroundColor: Colors.green,
              icon: Icon(Icons.done_all,color: Colors.white,size: 30,),
              duration: Duration(seconds: 3),
              isDismissible: false,
            )..show(context);
            setState(() {
              show=false;
            });
          });
        });
      });


    });
  }

  Widget circularProgress(){

    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.blueAccent
          ),
        );
      },
    );
  }
  Widget redProgress(){

    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.redAccent
          ),
        );
      },
    );
  }

  Widget requetsList(){
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.document(useruid[0]).collection("requests")
      //.orderBy("created_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: circularProgress(),);
        final int messageCount = snapshot.data.documents.length;
        if(messageCount > 0){
          return Padding(
            padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, int index) {
                final DocumentSnapshot document = snapshot.data.documents[index];
                final dynamic name = document['name'];
                final dynamic image = document['image'];
                final dynamic email = document['email'];
                final dynamic phone = document['phone'];
                final dynamic campus = document['campus'];
                final dynamic requester=document['requester'];

                return requestCard(name,image,email,phone,campus,requester);


                /*return counsellorCard(name,image,expertise,status,rating,document.documentID);*/
              },
            ),
          );
        }else{
          return Center(
            child: Text(
              "No Requests",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Raleway-regular'
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
