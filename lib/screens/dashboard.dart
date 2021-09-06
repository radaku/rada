import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:radauon/screens/contributors.dart';
import 'package:radauon/screens/counsellors.dart';
import 'package:radauon/screens/forum.dart';
import 'package:radauon/screens/help.dart';
import 'package:radauon/screens/information.dart';
import 'package:radauon/screens/login_screen.dart';
import 'package:radauon/screens/mentorshiplanding.dart';
import 'package:radauon/screens/notification.dart';
import 'package:radauon/screens/profile.dart';
import 'package:radauon/src/models/payment_model.dart';
import 'package:radauon/src/widgets/payment_card.dart';
import 'package:radauon/utils/details_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  String id;
  DashBoard({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool fetched = false;
  List useruid = [];
  bool synced;
  Map details;

  String devtoc =
      "d1BvTX2kS7ybFgQhRp227r:APA91bE33jdeCXiWZUzZeQ_OH4qifFxlJyJPt-rzXgVG_cUV-6ULVUXDIYTltYBWptUWt7zYhRMpaISTAb7D-Ew74QmXVLc9Gamg9mnzDyPIRpEisvIhqoMjXYcYKePCl0ovbNp34yTu";

  DetailsHelper detailsHelper;

  void getId() async {
    try {
      await _firebaseAuth.currentUser().then((FirebaseUser user) {
        useruid.add(user.uid);
        print(user.uid);
      });
    } catch (e) {
      print(e);
    }
  }

  void getSynced() async {
    Map d;
    try {
      await _firebaseAuth.currentUser().then((FirebaseUser user) {
        Firestore.instance
            .collection("Users")
            .document(user.uid)
            .get()
            .then((value) {
          Firestore.instance
              .collection("Mentors")
              .document(user.uid)
              .collection("requests")
              .getDocuments()
              .then((reqs) {
            synced = true;
            d = {
              "synced": value.data['synced'],
              "name": value.data['name'],
              "user_type": value.data['user_type'],
              "count": reqs.documents.length
            };
          }).then((value) {
            details = d;
            setState(() {
              fetched = true;
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  AppLifecycleState _mystate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailsHelper = DetailsHelper();
    setState(() {
      getId();
    });

    //getSynced();

    //shared();

    //sayOnline();

    /*_firebaseMessaging.getToken().then((deviceToken) {
      print(deviceToken);
    });*/
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _mystate = state;
    });
    if (_mystate.toString() == "AppLifecycleState.inactive" ||
        _mystate.toString() == "AppLifecycleState.paused" ||
        _mystate.toString() == "AppLifecycleState.detached") {
      sayOffline();
    } else {
      sayOnline();
    }
  }

  void sayOnline() async {
    try {
      await _firebaseAuth.currentUser().then((FirebaseUser user) {
        var documentReference =
            Firestore.instance.collection('Users').document(useruid[0]);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
            documentReference,
            {'status': "online"},
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void sayOffline() async {
    try {
      await _firebaseAuth.currentUser().then((FirebaseUser user) {
        var documentReference =
            Firestore.instance.collection('Users').document(useruid[0]);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
            documentReference,
            {'status': "offline"},
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @mustCallSuper
  @protected
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void shared() async {
    final SharedPreferences prefs = await _prefs;
    final savedNumber = prefs.getInt('savedNumber') ?? 0;
    print(savedNumber);
  }

  List<PaymentModel> getPaymentsCard() {
    List<PaymentModel> paymentCards = [
      PaymentModel("assets/images/knowledge.png", Color(0xFFffd60f),
          "Information", "Knowledge is power", "", Icons.arrow_forward, -1),
      PaymentModel(
          "assets/images/counsellor.png",
          Color(0xFFff415f),
          "Student Counselling",
          "Free professional counselling",
          "",
          Icons.arrow_forward,
          -1),
      PaymentModel(
          "assets/images/forum.png",
          Color(0xFF50f3e2),
          "Student Forums",
          "Share with the group",
          "",
          Icons.arrow_forward,
          -1),
      PaymentModel(
          "assets/images/bell.png",
          Colors.green,
          "Quick Notifications",
          "Instant notifications",
          "",
          Icons.arrow_forward,
          -1),
      PaymentModel("assets/images/information.png", Colors.green, "Help",
          "Locations and contacts", "", Icons.arrow_forward, -1),
      PaymentModel(
          "assets/images/mentor.png",
          Colors.green,
          "Student Mentorship",
          "Mentorship programs",
          "",
          Icons.arrow_forward,
          -1),
    ];

    return paymentCards;
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            margin: EdgeInsets.only(top: 25),
            child: Padding(
              padding: EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rada Dashboard",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    enabled: true,
                    onSelected: (str) {
                      if (str == "logout") {
                        signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else if (str == "profile") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    id: useruid[0],
                                  )),
                        );
                      } else if (str == "contributors") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => Contributors()));
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('profile'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'contributors',
                        child: Text('Contributors'),
                      ),
                      /*const PopupMenuItem<String>(
                                      value: 'profile',
                                      child: Text('User Profile'),
                                    ),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            width: _media.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    bottom: 15,
                    top: 15,
                  ),
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 85.0),
                            child: Divider(),
                          );
                        },
                        padding: EdgeInsets.zero,
                        itemCount: getPaymentsCard().length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (getPaymentsCard()[index].name ==
                                  "Information") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Information(
                                              synced: synced,
                                            )));
                              } else if (getPaymentsCard()[index].name ==
                                  "Student Counselling") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Counsellors()));
                              } else if (getPaymentsCard()[index].name ==
                                  "Student Forums") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Forum()));
                              } else if (getPaymentsCard()[index].name ==
                                  "Quick Notifications") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Notifications()));
                              } else if (getPaymentsCard()[index].name ==
                                  "Help") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Help()));
                              } else if (getPaymentsCard()[index].name ==
                                  "Student Mentorship") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MentorShipLanding(
                                              usertype: "user",
                                              id: useruid[0],
                                            )));
                              }
                              //print(getPaymentsCard()[index].name);
                            },
                            child: PaymentCardWidget(
                              payment: getPaymentsCard()[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}
