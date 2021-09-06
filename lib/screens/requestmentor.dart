import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../infocard.dart';

class RequestMentor extends StatefulWidget {

  String id;
  String image;
  String name;
  String status;
  String mentees;
  String phone;
  String email;

  RequestMentor({Key key, @required this.id,this.image,this.name,this.status,this.mentees,this.phone,this.email}) : super(key: key);

  @override
  _RequestMentorState createState() => _RequestMentorState();
}

class _RequestMentorState extends State<RequestMentor> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid=[];

  String loader="circular";

  var documentReference = Firestore.instance
      .collection('ForumRooms');

  @override
  void initState() {
    // TODO: implement initState
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
    Firestore.instance.collection("Mentors").document(widget.id).collection("requests").document(useruid[0]).snapshots().listen((event) {
      if(event.data==null){

        loader="norequest";

        /*Firestore.instance.collection("Mentors").document(widget.id).snapshots().forEach((element) {

        });*/

      }else{
        loader="sent";
      }
    });
    setState(() {
      getId();
    });
    return WillPopScope(

      onWillPop: (){
        Navigator.pop(context);
        return;
      },

        child: Scaffold(
          backgroundColor: Color(0xff1979a9),
          appBar: Platform.isIOS?AppBar(
              backgroundColor: Color(0xff1979a9),
              leading: Icon(Icons.arrow_back_ios,color: Colors.white,size: 27,),
              title: Text(
                "Mentorship request",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              elevation: 0,
              actions: <Widget>[
                Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.white,)),
              ],
          ):AppBar(
            backgroundColor: Color(0xff1979a9),
            leading: Icon(Icons.arrow_back,color: Colors.white,size: 27,),
            title: Text(
              "Mentorship request",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            elevation: 0,
            actions: <Widget>[
              Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.white,)),
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    child: Container(
                      height:150,
                      width: 150,
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        /*placeholder: (context, url) => Center(child: CircularProgressIndicator()),*/
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
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    widget.status,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueGrey[200],
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Source Sans Pro'),
                  ),
                  SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  /*InfoCard(
                    text: widget.phone,
                    icon: Icons.phone,
                    onPressed: () async {

                    },
                  ),*/
                  InfoCard(
                    text: widget.email,
                    icon: Icons.email,
                    onPressed: () async {
                    },
                  ),
                  InfoCard(
                    text: "Accepting ${widget.mentees} mentees",
                    icon: Icons.web,
                    onPressed: () async {

                    },
                  ),

                  loader=="norequest"?Padding(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child: ArgonButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 0.0,
                      color: Colors.orange,
                      roundLoadingShape: true,
                      child: Text(
                        "Send Request",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Raleway-regular',
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      loader: Container(
                        padding: EdgeInsets.all(10),
                        child: SpinKitPulse(
                          color: Colors.white,
                        ),
                      ),
                      onTap: (startLoading, stopLoading, btnState) {
                        startLoading();
                        sendRequest();
                        /*Navigator.of(context).pushNamed(DashBoard.routeName);*/
                        
                      },
                    ),
                  ):loader=="sent"?Text("Request has been sent",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),):loader=="circular"?circularProgress():SizedBox(),
                ],
              ),],
            ),
          ),
      )
    );
  }
  
  void sendRequest(){
    var dref=Firestore.instance.collection("Mentors").document(widget.id);
    Firestore.instance.collection("DeviceTokens").document(widget.id).get().then((devi){
      Firestore.instance.collection("Users").document(useruid[0]).get().then((value){
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            dref.collection("requests").document(useruid[0]),
            {
              'name': value.data["name"],
              'image': value.data["image"],
              'phone':value.data["phone"],
              'email':value.data["email"],
              'campus':value.data["campus"],
              'requester':useruid[0],
              'device':devi.data["device"],
              'created_at':DateTime.now()

            },
          );
        }).then((value){
          setState(() {
            loader="sent";
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
}
