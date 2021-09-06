
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radauon/screens/counsellors.dart';
import 'package:radauon/screens/forum.dart';
import 'package:radauon/screens/help.dart';
import 'package:radauon/screens/information.dart';
import 'package:radauon/screens/mentors.dart';
import 'package:radauon/screens/mentorship.dart';
import 'package:radauon/screens/mentorshiproom.dart';
import 'package:radauon/screens/notification.dart';

import 'screens/home.dart';

class GridDashboard extends StatefulWidget {

  String user_type;
  bool synced;
  String name;
  int count;

  GridDashboard({Key key, @required this.user_type,this.synced,this.name,this.count}) : super(key: key);


  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List counsellorcount=[];

  bool count=true;

  List useruid=[];

  Items item1 = new Items(
      title: "Information",
      subtitle: "Interactive content",
      event: "Knowledge is power",
      img: "assets/images/knowledge.png"
  );

  Items item2 = new Items(
    title: "Counsellors",
    subtitle: "Anonymous counselling",
    event: "End to end encrypted",
    img: "assets/images/counsellor.png",
  );

  Items item3 = new Items(
    title: "Forum",
    subtitle: "Student forums",
    event: "Chats",
    img: "assets/images/forum.png",
  );

  Items item4 = new Items(
    title: "Notifications",
    subtitle: "Instant notifications",
    event: "urgent",
    img: "assets/images/bell.png",
  );

  Items item5 = new Items(
    title: "More",
    subtitle: "Locations and contacts",
    event: "Ai bot",
    img: "assets/images/information.png",
  );

  Items item6 = new Items(
    title: "Mentorship",
    subtitle: "Mentorship programs",
    event: "Chats",
    img: "assets/images/mentor.png",
  );

  void getId() async{
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      useruid.add(user.uid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  void getCounter(){
    Firestore.instance.collection("CounsellorsCounter").document(useruid[0]).get().then((value) {
      value.data.forEach((key, val) {
        counsellorcount.add(val);
        print(counsellorcount.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    /*if(count){
      Firestore.instance.collection("CounsellorsCounter").document(useruid[0]).collection("count").getDocuments().then((value){
      counsellorcount.add(value.documents);
      count=false;
    }).then((value){
        setState(() {
          count=false;
        });
      });
    }*/

    /*Firestore.instance.collection("CounsellorsCounter").document(useruid[0]).collection("count").getDocuments().then((value){
      counsellorcount.add(value.documents);
    });*/

    getId();
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    List<bool> grid = [false,true,true,true,false,true];
    var color = 0xffB8275E;
    /*return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: (){
                if(data.title=="Information"){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Information(synced: widget.synced,)));
                }else if(data.title=="Counsellors"){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Counsellors()));
                }else if(data.title=="Forum"){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Forum()));
                }else if(data.title=="Notifications"){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Notifications()));
                }else if(data.title=="More"){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Help()));
                }else if(data.title=="Mentorship"){
                  if(widget.user_type=="user"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Mentors(id:useruid[0],name:widget.name,type:widget.user_type,count:0)));
                  }else if(widget.user_type=="mentor"){
                    //Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MentorshipRoom(id:useruid[0],title:value.data["name"],image: value.data["image"],)));
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Mentors(id:useruid[0],name:widget.name,type:widget.user_type,count:widget.count)));
                  }

                }
              },
              child: Container(
                decoration: BoxDecoration(


                    *//*color: Color(0xff1979a9), borderRadius: BorderRadius.circular(13)),*//*
                    color: Color(0xff195e83), borderRadius: BorderRadius.circular(13)),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 35,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(height: 20,width: 20,),
                          Padding(
                            padding: EdgeInsets.only(right: 5,top: 1),
                            child: Badge(
                              badgeColor: Colors.green[400],
                              shape: BadgeShape.circle,
                              borderRadius: 20,
                              toAnimate: false,
                              elevation: 0,
                              badgeContent:
                              Padding(padding: EdgeInsets.all(5),child: Text('2', style: TextStyle(
                                  color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      data.img,
                      width: 42,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        data.event,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );*/

    return Flexible(
        child: GridView.builder(
          itemCount: 6,
          itemBuilder: (context, index) =>
              GestureDetector(
                onTap: (){
                  if(myList[index].title=="Information"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Information(synced: widget.synced,)));
                  }else if(myList[index].title=="Counsellors"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Counsellors()));
                  }else if(myList[index].title=="Forum"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Forum()));
                  }else if(myList[index].title=="Notifications"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Notifications()));
                  }else if(myList[index].title=="More"){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Help()));
                  }else if(myList[index].title=="Mentorship"){
                    if(widget.user_type=="user"){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Mentors(id:useruid[0],name:widget.name,type:widget.user_type,count:0)));
                    }else if(widget.user_type=="mentor"){
                      //Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MentorshipRoom(id:useruid[0],title:value.data["name"],image: value.data["image"],)));
                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Mentors(id:useruid[0],name:widget.name,type:widget.user_type,count:widget.count)));
                    }

                  }
                },
                child: Container(
                  decoration: BoxDecoration(


                    color: Color(0xff1979a9), borderRadius: BorderRadius.circular(13)),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(height: 20,width: 20,),
                            Padding(
                              padding: EdgeInsets.only(right: 5,top: 1),
                              child: index==1?Badge(
                                //Bage 1
                                badgeColor: Colors.green[400],
                                shape: BadgeShape.circle,
                                borderRadius: 20,
                                toAnimate: false,
                                elevation: 0,
                                badgeContent:
                                Padding(padding: EdgeInsets.all(5),child: Text(counsellorcount.length.toString(), style: TextStyle(
                                    color: Colors.white))),
                              ):index==2?Badge(
                                //Badge 2
                                badgeColor: Colors.green[400],
                                shape: BadgeShape.circle,
                                borderRadius: 20,
                                toAnimate: false,
                                elevation: 0,
                                badgeContent:
                                Padding(padding: EdgeInsets.all(5),child: Text('2', style: TextStyle(
                                    color: Colors.white))),
                              ):index==3?Badge(
                                //Badge 3
                                badgeColor: Colors.green[400],
                                shape: BadgeShape.circle,
                                borderRadius: 20,
                                toAnimate: false,
                                elevation: 0,
                                badgeContent:
                                Padding(padding: EdgeInsets.all(5),child: Text('2', style: TextStyle(
                                    color: Colors.white))),

                              ):index==5?Badge(
                                //Badge 4
                                badgeColor: Colors.green[400],
                                shape: BadgeShape.circle,
                                borderRadius: 20,
                                toAnimate: false,
                                elevation: 0,
                                badgeContent:
                                Padding(padding: EdgeInsets.all(5),child: Text('2', style: TextStyle(
                                    color: Colors.white))),
                                ):SizedBox())
                          ],
                        ),
                      ),
                      Image.asset(
                        myList[index].img,
                        width: 42,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        myList[index].title,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.grey[100],
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        myList[index].subtitle,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          myList[index].event,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Divider(thickness: 1,color: Colors.white.withAlpha(60),)
                    ],
                  ),
                ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 38,
                  childAspectRatio: 1,
              ),
        )
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({this.title, this.subtitle, this.event, this.img});
}
