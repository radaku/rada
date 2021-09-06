import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivityswift/connectivityswift.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/article.dart';
import 'package:radauon/screens/content.dart';
import 'package:radauon/screens/drugscontent.dart';
import 'package:radauon/screens/healthcontent.dart';
import 'package:radauon/screens/hivcontent.dart';
import 'package:radauon/screens/mentalcontent.dart';
import 'package:radauon/screens/otherscontent.dart';
import 'package:radauon/screens/safetycontent.dart';
import 'package:radauon/utils/details_helper.dart';
import 'package:radauon/utils/drugs_helper.dart';
import 'package:radauon/utils/health_helper.dart';
import 'package:radauon/utils/hiv_helper.dart';
import 'package:radauon/utils/mental_helper.dart';
import 'package:radauon/utils/others_helper.dart';
import 'package:radauon/utils/reproductive_helper.dart';
import 'package:radauon/utils/safety_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_persistence/state_persistence.dart';

class Information extends StatefulWidget {
  bool synced;

  Information({Key key, @required this.synced}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid = [];

  int dsync = 0;

  bool showSpinner = false;

  Map data;
  Map news;
  Map data_hiv;
  List data_list = [];
  List hiv_data = [];
  List categories = [3, 4, 5, 6, 7, 8, 9];
  ReproHelper reproHelper;
  HivHelper hivHelper;
  SafetyHelper safetyHelper;
  DrugsHelper drugsHelper;
  MentalHelper mentalHelper;
  HealthHelper healthHelper;
  OthersHelper othersHelper;
  DetailsHelper detailsHelper;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Map> imgList = [];
  final List<Map> newsList = [];

  void getNews() async {
    print('Fetching Contacts...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/news/get',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }

    for (var i = 0; i < newsList.length; i++) {
      /*imgList.add(
        {"title":data[i]["title"],"image":data[i]["image"],"content":data[i]["news"]}
      );*/
      imgList.add(newsList[i]);
      //print(imgList);
    }
    //print(newsList[0]["title"]);
  }

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      useruid.add(user.uid);
    });
  }

  void getSync() async {
    final SharedPreferences prefs = await _prefs;
    //prefs.setInt('savedNumber', 1);
    final synced = prefs.getInt('synced') ?? 0;
    dsync = synced;
    /*print("Is it synced ? "+synced.toString());*/
  }

  @override
  void initState() {
    super.initState();
    getNews();
    reproHelper = ReproHelper();
    hivHelper = HivHelper();
    safetyHelper = SafetyHelper();
    drugsHelper = DrugsHelper();
    mentalHelper = MentalHelper();
    healthHelper = HealthHelper();
    othersHelper = OthersHelper();
    detailsHelper = DetailsHelper();

    getSync();

    setState(() {
      getId();
    });
  }

  /*@override
  void dispose() {
    showSpinner = false;
    super.dispose();
  }*/

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

  void fetchData() async {
    print("Fetcing Data");

    final SharedPreferences prefs = await _prefs;
    //prefs.setInt('savedNumber', 1);
    final synced = prefs.getInt('synced') ?? 0;
    print("Is it synced ? " + synced.toString());

    if (synced == 1) {
      //updateContent(synced);
      var _connectivity = Connectivityswift();
      var connectivityResult = await _connectivity.checkConnectivity();
      // var connectivityResult = await (Connectivity().checkConnectivity());
      /*if (connectivityResult == ConnectivityResult.mobile) {*/
      if ((connectivityResult != ConnectivityResult.mobile) &&
          (connectivityResult != ConnectivityResult.wifi)) {
        Flushbar(
          title: "No Connection",
          message: "No Interet Connection",
          icon: Icon(
            Icons.done_all,
            color: Colors.white,
            size: 30,
          ),
          duration: Duration(seconds: 3),
          isDismissible: false,
          backgroundColor: Colors.pink,
        )..show(context);
      } else {
        await updateContent(synced);
      }
    } else if (synced == null || synced == 0) {
      var _connectivity = Connectivityswift();
      var connectivityResult = await _connectivity.checkConnectivity();
      // var connectivityResult = await (Connectivity().checkConnectivity());
      /*if (connectivityResult == ConnectivityResult.mobile) {*/
      if ((connectivityResult != ConnectivityResult.mobile) &&
          (connectivityResult != ConnectivityResult.wifi)) {
        Flushbar(
          title: "No Connection",
          message: "No Interet Connection",
          icon: Icon(
            Icons.done_all,
            color: Colors.white,
            size: 30,
          ),
          duration: Duration(seconds: 3),
          isDismissible: false,
          backgroundColor: Colors.pink,
        )..show(context);
      } else {
        await getContent(synced);
      }
    }
  }

  Future<void> _shareText(String text) async {
    try {
      Share.text('Share to', text, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getId();
    });
    return PersistedAppState(
      storage: JsonFileStorage(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: Platform.isAndroid?AppBar(
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
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                    onTap: () {
                      fetchData();
                    },
                    child: Icon(
                      Icons.sync,
                      size: 27,
                      color: Colors.black,
                    )))
          ],
          title: NeumorphicText(
            "Rada Information",
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
        ):AppBar(
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
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                    onTap: () {
                      fetchData();
                    },
                    child: Icon(
                      Icons.sync,
                      size: 27,
                      color: Colors.black,
                    )))
          ],
          title: NeumorphicText(
            "Rada Information",
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
        body: PersistedStateBuilder(builder:
            (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "News And Other Announcements",
                                style: TextStyle(
                                    fontFamily: 'Raleway-regular',
                                    color: Colors.white),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                    height: 210,
                    child: imgList.isEmpty
                        ? Center(
                            child: Text("Fetching News ..."),
                          )
                        : CarouselSlider.builder(
                            itemCount: imgList.length,
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              enlargeCenterPage: false,
                              reverse: true,
                              pauseAutoPlayOnTouch: true,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  print(imgList[index]["content"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ArticlePage(
                                                title: imgList[index]["title"],
                                                image: imgList[index]["image"],
                                                content: imgList[index]
                                                    ["content"],
                                              )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                            imageUrl: imgList[index]["image"],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                          colorFilter:
                                                              const ColorFilter
                                                                  .mode(
                                                            Colors.white,
                                                            BlendMode.colorBurn,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: circularProgress()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.error,
                                                        size: 40,
                                                      ),
                                                    )),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                              constraints: new BoxConstraints(
                                                minHeight: 20.0,
                                                maxHeight: 60.0,
                                              ),
                                              //height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Colors.black54,
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
                                                        imgList[index]["title"],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Raleway-regular'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              _shareText(
                                                  imgList[index]["content"]);
                                            },
                                            child: Icon(
                                              Icons.share,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Alcohol & Drug Abuse",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        listCard(
                            'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/drugs.jpg',
                            "Weed",
                            1,
                            "6",
                            dsync),
                        listCard(
                            'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/heroine.jpg',
                            "Heroine",
                            2,
                            "6",
                            dsync),
                        listCard(
                            'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/alcohol.jpg',
                            "Alcohol",
                            3,
                            "6",
                            dsync),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Sexual & Reproductive Health",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/romance.jpg',
                          "Relationships",
                          5,
                          "3",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/pregnancy.jpg',
                          "Pregnancy",
                          6,
                          "3",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/contraception.jpg',
                          "Contraception",
                          7,
                          "3",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/bacteria.png',
                          "STIs",
                          8,
                          "3",
                          dsync)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "General Health",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/communicable.jpg',
                          "Non Communicable...",
                          13,
                          "8",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/food.jpg',
                          "Nutrition",
                          14,
                          "8",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/hygiene.png',
                          "Personal Hygiene",
                          15,
                          "8",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/physical.jpg',
                          "Physical Activities",
                          16,
                          "8",
                          dsync),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Mental Health",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/illness.jpg',
                          "Mental Illnesses",
                          9,
                          "7",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/suicide.jpg',
                          "Suicide",
                          10,
                          "7",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/eating.jpg',
                          "Eating disorders",
                          11,
                          "7",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/help.jpg',
                          "Get Help",
                          12,
                          "7",
                          dsync)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Safety",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/dating.jpg',
                          "Dating",
                          13,
                          "5",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/gbv.jpg',
                          "GBV",
                          14,
                          "5",
                          dsync),
                      listCard(
                          /*'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/ccrime.png',*/
                          "https://1c7fab3im83f5gqiow2qqs2k-wpengine.netdna-ssl.com/wp-content/uploads/2018/05/cybercrimedirectory.jpg",
                          "Cyber Crimes",
                          15,
                          "5",
                          dsync),
                      /*listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/safety.jpg',
                          "Safety Tips",
                          16,
                          "5",
                          dsync),*/
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/csafety.jpg',
                          "Campus Safety",
                          16,
                          "5",
                          dsync),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "HIV & AIDS",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/romance.jpg',
                          "HIV",
                          13,
                          "4",
                          dsync),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Career & Financial Management",
                                  style: TextStyle(
                                      fontFamily: 'Raleway-regular',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/coins.jpg',
                          "College Financial...",
                          13,
                          "9",
                          dsync),
                      listCard(
                          'http://rada.uonbi.ac.ke/radaweb/appimages/dashboard/career.jpg',
                          "Career",
                          14,
                          "9",
                          dsync),
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
        }),
      ),
    );
  }

  Future<void> _showMyDialog(String itemKey, synced) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Sync Data'),
          insetAnimationDuration: Duration(milliseconds: 1000),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Text('Fetch Data.'),
                Text(
                  'Syncing is required the first time to fetch data',
                  style: TextStyle(
                      fontFamily: 'Raleway-regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: RaisedButton(
                color: Colors.green,
                child: Text(
                  'Sync',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  getContent(
                    synced,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: RaisedButton(
                color: Colors.orange,
                child: Text(
                  'Not now',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> updateContent(synced) async {
    print("Stating Update .........");
    Flushbar(
      title: "Syncing",
      message: "Syncing data please wait",
      icon: Icon(
        Icons.done_all,
        color: Colors.white,
        size: 30,
      ),
      duration: Duration(seconds: 3),
      isDismissible: false,
      backgroundColor: Colors.pink,
    )..show(context);

    for (var k in categories) {
      http.Response response = await http.get(
          'http://rada.uonbi.ac.ke/radaweb/categories/get/$k',
          headers: {"Accept": "application/json"});

      var converted = await json.decode(response.body);
      for (var i = 0; i < converted.length; i++) {
        data = converted[i];
        setState(() {
          data_list.add(data);
        });
      }
    }

    //updating data here start

    drugsHelper.delete().then((value) {
      drugsHelper.save({
        'name': data_list[3]["name"],
        "alcoholintroduction": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
        "alcoholismsigns": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
        "associatedhealthissues": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
        "alcoholismtreatment": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
        "alcoholismhelp": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
        "alcoholhelpcontacts": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
        "alcoholvideo": data_list[3]["category_sub_cat"][0]
            ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
        "heroineintro": data_list[3]["category_sub_cat"][1]
            ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
        "heroineeffects": data_list[3]["category_sub_cat"][1]
            ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
        "heroineinjection": data_list[3]["category_sub_cat"][1]
            ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
        "heroinerecovery": data_list[3]["category_sub_cat"][1]
            ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
        "heroinefurtherhelp": data_list[3]["category_sub_cat"][1]
            ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
        "weedintro": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [0]["sub_sub_cat_content"][0]['content'],
        "weeddyn": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [1]["sub_sub_cat_content"][0]['content'],
        "weedmyths": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [2]["sub_sub_cat_content"][0]['content'],
        "weedfacts": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [3]["sub_sub_cat_content"][0]['content'],
        "quitweed": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [4]["sub_sub_cat_content"][0]['content'],
        "weednote": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [5]["sub_sub_cat_content"][0]['content'],
        "weedfaq": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [6]["sub_sub_cat_content"][0]['content'],
        "weedhelp": data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"]
            [7]["sub_sub_cat_content"][0]['content'],
        'created_at': DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) {
        reproHelper.delete().then((value) {
          reproHelper.save({
            'name': data_list[0]["name"],
            "boyfriend": data_list[0]["category_sub_cat"][0]
                    ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                ['content'],
            "night": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"]
                [2]["sub_sub_cat_content"][0]['content'],
            "casual": data_list[0]["category_sub_cat"][0]
                    ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                ['content'],
            "sponsor": data_list[0]["category_sub_cat"][0]
                    ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                ['content'],
            "dyn1": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"]
                [0]["sub_sub_cat_content"][0]['content'],
            "sponsorvideo": data_list[0]["category_sub_cat"][0]
                    ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                ['content'],
            "sponsorvideo": "I updated this myself",

            //Null values
            "contraceptionintroduction": null,
            "methods": null,
            "condomswork": null,
            "injectable": null,
            "oralpill": null,
            "iucds": null,
            "implants": null,
            "emergency": null,
            "contraceptionvideo": null,

            "pregnancydyn": null,
            "pregnancycauses": null,
            "pregnancysigns": null,
            "pregnancytest": null,
            "prenatalcare": null,
            "antinetalcare": null,
            "postnatal": null,
            "pregnancynutrition": null,
            "pregnancydanger": null,

            "stiintroduction": null,
            "riskfactors": null,
            "stitypes": null,
            "stisigns": null,
            "commonstisigns": null,
            "treatment": null,
            "protectiontips": null,
            "facts": null,
            "myths": null,
            'stisharm': null,
            'hivsti': null,
            'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
          }).then((value) {
            reproHelper.save({
              'name': data_list[0]["name"],
              "contraceptionintroduction": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                  ['content'],
              "methods": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                  ['content'],
              "condomswork": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                  ['content'],
              "injectable": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                  ['content'],
              "oralpill": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                  ['content'],
              "iucds": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                  ['content'],
              "implants": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                  ['content'],
              "emergency": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                  ['content'],
              "contraceptionvideo": data_list[0]["category_sub_cat"][1]
                      ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                  ['content'],

              //Null fields
              "boyfriend": null,
              "night": null,
              "casual": null,
              "sponsor": null,
              "dyn1": null,
              "sponsorvideo": null,

              "pregnancydyn": null,
              "pregnancycauses": null,
              "pregnancysigns": null,
              "pregnancytest": null,
              "prenatalcare": null,
              "antinetalcare": null,
              "postnatal": null,
              "pregnancynutrition": null,
              "pregnancydanger": null,

              "stiintroduction": null,
              "riskfactors": null,
              "stitypes": null,
              "stisigns": null,
              "commonstisigns": null,
              "treatment": null,
              "protectiontips": null,
              "facts": null,
              "myths": null,
              'stisharm': null,
              'hivsti': null,

              'created_at': DateTime.now().millisecondsSinceEpoch.toString()
            }).then((value) {
              reproHelper.save({
                'name': data_list[0]["name"],
                "pregnancydyn": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],
                "pregnancycauses": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                    ['content'],
                "pregnancysigns": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                    ['content'],
                "pregnancytest": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                    ['content'],
                "prenatalcare": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                    ['content'],
                "antinetalcare": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                    ['content'],
                "postnatal": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                    ['content'],
                "pregnancynutrition": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                    ['content'],
                "pregnancydanger": data_list[0]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]
                    ['content'],

                //Null values
                "contraceptionintroduction": null,
                "methods": null,
                "condomswork": null,
                "injectable": null,
                "oralpill": null,
                "iucds": null,
                "implants": null,
                "emergency": null,
                "contraceptionvideo": null,

                "boyfriend": null,
                "night": null,
                "casual": null,
                "sponsor": null,
                "dyn1": null,
                "sponsorvideo": null,

                "stiintroduction": null,
                "riskfactors": null,
                "stitypes": null,
                "stisigns": null,
                "commonstisigns": null,
                "treatment": null,
                "protectiontips": null,
                "facts": null,
                "myths": null,
                'stisharm': null,
                'hivsti': null,

                'created_at': DateTime.now().millisecondsSinceEpoch.toString()
              }).then((value) {
                reproHelper.save({
                  'name': data_list[0]["name"],
                  "stiintroduction": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                      ['content'],
                  "riskfactors": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                      ['content'],
                  "stitypes": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                      ['content'],
                  "stisigns": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                      ['content'],
                  "commonstisigns": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                      ['content'],
                  "treatment": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                      ['content'],
                  "protectiontips": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                      ['content'],
                  "facts": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]
                      ['content'],
                  "myths": data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][9]["sub_sub_cat_content"][0]
                      ['content'],
                  'stisharm': data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][10]["sub_sub_cat_content"][0]
                      ['content'],
                  'hivsti': data_list[0]["category_sub_cat"][3]
                          ["sub_category_sub_cat"][11]["sub_sub_cat_content"][0]
                      ['content'],
                  "contraceptionintroduction": null,
                  "methods": null,
                  "condomswork": null,
                  "injectable": null,
                  "oralpill": null,
                  "iucds": null,
                  "implants": null,
                  "emergency": null,
                  "contraceptionvideo": null,
                  "pregnancydyn": null,
                  "pregnancycauses": null,
                  "pregnancysigns": null,
                  "pregnancytest": null,
                  "prenatalcare": null,
                  "antinetalcare": null,
                  "postnatal": null,
                  "pregnancynutrition": null,
                  "pregnancydanger": null,
                  "boyfriend": null,
                  "night": null,
                  "casual": null,
                  "sponsor": null,
                  "dyn1": null,
                  "sponsorvideo": null,
                  'created_at': DateTime.now().millisecondsSinceEpoch.toString()
                }).then((value) {
                  hivHelper.delete().then((value) {
                    hivHelper.save({
                      'name': data_list[1]["name"],
                      "kenyahiv": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                          [0]['content'],
                      "definition": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                          [0]['content'],
                      "hivsymptoms": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                          [0]['content'],
                      "transmissionmodes": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                          [0]['content'],
                      "nottransmitted": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                          [0]['content'],
                      "hivmyths": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][5]["sub_sub_cat_content"]
                          [0]['content'],
                      "hivprevention": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][6]["sub_sub_cat_content"]
                          [0]['content'],
                      "mothertochild": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][7]["sub_sub_cat_content"]
                          [0]['content'],
                      "hivstigma": data_list[1]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][8]["sub_sub_cat_content"]
                          [0]['content'],
                      'created_at':
                          DateTime.now().millisecondsSinceEpoch.toString()
                    }).then((value) {
                      print("Hiv Data Updated");
                      healthHelper.delete().then((value) {
                        healthHelper.save({
                          'name': data_list[5]["name"],
                          "noncommunicableintro": data_list[5]
                                      ["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][0]
                              ["sub_sub_cat_content"][0]['content'],
                          "keyriskfactors": data_list[5]["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][1]
                              ["sub_sub_cat_content"][0]['content'],
                          "poorlifestyles": data_list[5]["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][2]
                              ["sub_sub_cat_content"][0]['content'],
                          "healthylifestyles": data_list[5]["category_sub_cat"]
                                  [0]["sub_category_sub_cat"][3]
                              ["sub_sub_cat_content"][0]['content'],
                          "weightobesity": data_list[5]["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][4]
                              ["sub_sub_cat_content"][0]['content'],
                          "weightmanagement": data_list[5]["category_sub_cat"]
                                  [0]["sub_category_sub_cat"][4]
                              ["sub_sub_cat_content"][0]['content'],
                          "weightmanagementrecons": data_list[5]
                                      ["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][5]
                              ["sub_sub_cat_content"][0]['content'],
                          "weightmanagementhelp": data_list[5]
                                      ["category_sub_cat"][0]
                                  ["sub_category_sub_cat"][6]
                              ["sub_sub_cat_content"][0]['content'],
                          "nutritionintro": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][0]
                              ["sub_sub_cat_content"][0]['content'],
                          "foodproduction": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][1]
                              ["sub_sub_cat_content"][0]['content'],
                          "foodconsumption": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][2]
                              ["sub_sub_cat_content"][0]['content'],
                          "nutrientutilization": data_list[5]
                                      ["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][3]
                              ["sub_sub_cat_content"][0]['content'],
                          "posthavest": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][4]
                              ["sub_sub_cat_content"][0]['content'],
                          "physicalinactivity": data_list[5]["category_sub_cat"]
                                  [1]["sub_category_sub_cat"][5]
                              ["sub_sub_cat_content"][0]['content'],
                          "nutrientsources": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][6]
                              ["sub_sub_cat_content"][0]['content'],
                          "nutritionandpregnancy": data_list[5]
                                      ["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][7]
                              ["sub_sub_cat_content"][0]['content'],
                          "nutritionandhiv": data_list[5]["category_sub_cat"][1]
                                  ["sub_category_sub_cat"][8]
                              ["sub_sub_cat_content"][0]['content'],
                          "hygieneintro": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][0]
                              ["sub_sub_cat_content"][0]['content'],
                          "hygieneimportance": data_list[5]["category_sub_cat"]
                                  [2]["sub_category_sub_cat"][1]
                              ["sub_sub_cat_content"][0]['content'],
                          "goodhabits": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][2]
                              ["sub_sub_cat_content"][0]['content'],
                          "emergencyplanning": data_list[5]["category_sub_cat"]
                                  [2]["sub_category_sub_cat"][3]
                              ["sub_sub_cat_content"][0]['content'],
                          "selfmaintainace": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][4]
                              ["sub_sub_cat_content"][0]['content'],
                          "offensivehabits": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][5]
                              ["sub_sub_cat_content"][0]['content'],
                          "support": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][6]
                              ["sub_sub_cat_content"][0]['content'],
                          "remember": data_list[5]["category_sub_cat"][2]
                                  ["sub_category_sub_cat"][7]
                              ["sub_sub_cat_content"][0]['content'],
                          "physicalintro": data_list[5]["category_sub_cat"][3]
                                  ["sub_category_sub_cat"][0]
                              ["sub_sub_cat_content"][0]['content'],
                          "benefits": data_list[5]["category_sub_cat"][3]
                                  ["sub_category_sub_cat"][1]
                              ["sub_sub_cat_content"][0]['content'],
                          'created_at':
                              DateTime.now().millisecondsSinceEpoch.toString()
                        }).then((value) {
                          print("Health Saved Successfully");
                          mentalHelper.delete().then((value) {
                            print("Mental Content deleted");
                            mentalHelper.save({
                              'name': data_list[4]["name"],
                              "mentaldef": data_list[4]["category_sub_cat"][0]
                                      ["sub_category_sub_cat"][0]
                                  ["sub_sub_cat_content"][0]['content'],
                              "mentalilldef": data_list[4]["category_sub_cat"]
                                      [0]["sub_category_sub_cat"][1]
                                  ["sub_sub_cat_content"][0]['content'],
                              "riskfactors": data_list[4]["category_sub_cat"][0]
                                      ["sub_category_sub_cat"][2]
                                  ["sub_sub_cat_content"][0]['content'],
                              "disorders": data_list[4]["category_sub_cat"][0]
                                      ["sub_category_sub_cat"][3]
                                  ["sub_sub_cat_content"][0]['content'],
                              "suicideprevention": data_list[4]
                                          ["category_sub_cat"][1]
                                      ["sub_category_sub_cat"][0]
                                  ["sub_sub_cat_content"][0]['content'],
                              "suicidehelp": data_list[4]["category_sub_cat"][1]
                                      ["sub_category_sub_cat"][1]
                                  ["sub_sub_cat_content"][0]['content'],
                              "suicidevideo": data_list[4]["category_sub_cat"]
                                      [1]["sub_category_sub_cat"][2]
                                  ["sub_sub_cat_content"][0]['content'],
                              "eatingdisordersinto": data_list[4]
                                          ["category_sub_cat"][2]
                                      ["sub_category_sub_cat"][0]
                                  ["sub_sub_cat_content"][0]['content'],
                              "anorexia": data_list[4]["category_sub_cat"][2]
                                      ["sub_category_sub_cat"][1]
                                  ["sub_sub_cat_content"][0]['content'],
                              "bulimia": data_list[4]["category_sub_cat"][2]
                                      ["sub_category_sub_cat"][2]
                                  ["sub_sub_cat_content"][0]['content'],
                              "biengeeating": data_list[4]["category_sub_cat"]
                                      [2]["sub_category_sub_cat"][3]
                                  ["sub_sub_cat_content"][0]['content'],
                              "eatinghelp": data_list[4]["category_sub_cat"][2]
                                      ["sub_category_sub_cat"][4]
                                  ["sub_sub_cat_content"][0]['content'],
                              "mentalhelpintro": data_list[4]
                                          ["category_sub_cat"][3]
                                      ["sub_category_sub_cat"][0]
                                  ["sub_sub_cat_content"][0]['content'],
                              "psychotherapy": data_list[4]["category_sub_cat"]
                                      [3]["sub_category_sub_cat"][1]
                                  ["sub_sub_cat_content"][0]['content'],
                              "medication": data_list[4]["category_sub_cat"][3]
                                      ["sub_category_sub_cat"][2]
                                  ["sub_sub_cat_content"][0]['content'],
                              "selfhelp": data_list[4]["category_sub_cat"][3]
                                      ["sub_category_sub_cat"][3]
                                  ["sub_sub_cat_content"][0]['content'],
                              'created_at': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString()
                            }).then((value) {
                              print("Mental Content Saved");
                              safetyHelper.delete().then((value) {
                                print("Safety Contetnt Deleted");
                                safetyHelper.save({
                                  'name': data_list[2]["name"],
                                  "safedating": data_list[2]["category_sub_cat"]
                                          [0]["sub_category_sub_cat"][0]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "datingrules": data_list[2]
                                              ["category_sub_cat"][0]
                                          ["sub_category_sub_cat"][1]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "formen": data_list[2]["category_sub_cat"][0]
                                          ["sub_category_sub_cat"][2]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "forladies": data_list[2]["category_sub_cat"]
                                          [0]["sub_category_sub_cat"][3]
                                      ["sub_sub_cat_content"][0]['content'],
                                  //"datingtips":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                  //"cybercrimes":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                                  "safetytips": data_list[2]["category_sub_cat"]
                                          [0]["sub_category_sub_cat"][0]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "campussafetytips": data_list[2]
                                              ["category_sub_cat"][4]
                                          ["sub_category_sub_cat"][1]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "campussafety": data_list[2]
                                              ["category_sub_cat"][4]
                                          ["sub_category_sub_cat"][0]
                                      ["sub_sub_cat_content"][0]['content'],

                                  "cybercrimesintro": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][0]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "cybercrimestips": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][2]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "cybercrimestypes": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][1]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "cyberlaws": data_list[2]["category_sub_cat"]
                                          [2]["sub_category_sub_cat"][7]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "socialmediabenefits": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][4]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "socialmediapitfalls": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][5]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "socialmediarules": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][6]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "socialmediasafety": data_list[2]
                                              ["category_sub_cat"][2]
                                          ["sub_category_sub_cat"][3]
                                      ["sub_sub_cat_content"][0]['content'],

                                  "gbvintro": data_list[2]["category_sub_cat"]
                                          [1]["sub_category_sub_cat"][0]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "prominentplaces": data_list[2]
                                              ["category_sub_cat"][1]
                                          ["sub_category_sub_cat"][1]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "protectyourself": data_list[2]
                                              ["category_sub_cat"][1]
                                          ["sub_category_sub_cat"][2]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "gbveffects": data_list[2]["category_sub_cat"]
                                          [1]["sub_category_sub_cat"][3]
                                      ["sub_sub_cat_content"][0]['content'],
                                  "gettinghelp": data_list[2]
                                              ["category_sub_cat"][1]
                                          ["sub_category_sub_cat"][4]
                                      ["sub_sub_cat_content"][0]['content'],

                                  'created_at': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString()
                                }).then((value) {
                                  print("Safety Content Updated");
                                  othersHelper.delete().then((value) {
                                    print("Others Content Deleted");
                                    othersHelper.save({
                                      'name': data_list[6]["name"],
                                      "introduction": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][0]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "seventips": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][1]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "savingmoney": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][2]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "takeaction": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][3]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "moneysavingtips": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][4]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "earnextracoin": data_list[6]
                                                  ["category_sub_cat"][0]
                                              ["sub_category_sub_cat"][5]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "gratuationjob": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][0]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "careerresourses": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][1]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "internships": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][2]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "cvletter": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][3]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "professionaljobs": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][4]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "alumni": data_list[6]["category_sub_cat"]
                                              [1]["sub_category_sub_cat"][5]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "recentgratuates": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][6]
                                          ["sub_sub_cat_content"][0]['content'],
                                      "createopportunities": data_list[6]
                                                  ["category_sub_cat"][1]
                                              ["sub_category_sub_cat"][7]
                                          ["sub_sub_cat_content"][0]['content'],
                                      'created_at': DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString()
                                    }).then((value) {
                                      var documentReference = Firestore.instance
                                          .collection('Users')
                                          .document(useruid[0]);
                                      Firestore.instance
                                          .runTransaction((transaction) async {
                                        await transaction.update(
                                          documentReference,
                                          {'synced': true},
                                        );
                                      }).then((value) {
                                        /*PersistedStateBuilder(

                                          builder: (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
                                            snapshot.data["synced"]=true;
                                            return SizedBox(height: 0,width: 0,);
                                          },

                                        );*/

                                        Flushbar(
                                          title: "Success",
                                          message: "Data Updated Successfully",
                                          icon: Icon(
                                            Icons.done_all,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          duration: Duration(seconds: 3),
                                          isDismissible: false,
                                          backgroundColor: Colors.green,
                                        )..show(context);
                                        //print("Saved Others Data successfully");
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });

    //updating data ends here

    ///deleteing starts here
    /*drugsHelper.delete().then((value){
      print("Deleted drugs content");
      reproHelper.delete().then((value){
        print("Deleted repro content");
        healthHelper.delete().then((value){
          print("Deleted health content");
          mentalHelper.delete().then((value){
            print("Deleted mental content");
            safetyHelper.delete().then((value){
              print("Deleted safety content");
              hivHelper.delete().then((value){
                print("Deleted hiv content");
                othersHelper.delete().then((value){
                  print("Deleted all of them");
                }).then((value){
                  if(data_list[0]["name"].toString()=="Sexual and Reproductive Health"){
                    for(var i=0;i<data_list[0]["category_sub_cat"].length;i++){

                      //1
                      if(data_list[0]["category_sub_cat"][i]["name"]=="Campus Sexual Relationships"){
                        reproHelper.save({
                          'name': data_list[0]["name"],
                          "boyfriend":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                          "night":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                          "casual":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                          "sponsor":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                          "dyn1":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                          "sponsorvideo":data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                          "sponsorvideo":"I updated this myself",

                          //Null values
                          "contraceptionintroduction":null,
                          "methods":null,
                          "condomswork":null,
                          "injectable":null,
                          "oralpill":null,
                          "iucds":null,
                          "implants":null,
                          "emergency":null,
                          "contraceptionvideo":null,

                          "pregnancydyn":null,
                          "pregnancycauses":null,
                          "pregnancysigns":null,
                          "pregnancytest":null,
                          "prenatalcare":null,
                          "antinetalcare":null,
                          "postnatal":null,
                          "pregnancynutrition":null,
                          "pregnancydanger":null,

                          "stiintroduction":null,
                          "riskfactors":null,
                          "stitypes":null,
                          "stisigns":null,
                          "commonstisigns":null,
                          "treatment":null,
                          "protectiontips":null,
                          "facts":null,
                          "myths":null,
                          'stisharm':null,
                          'hivsti':null,
                          'created_at':DateTime.now().millisecondsSinceEpoch.toString(),

                        }).then((value){
                          print("Saved successfully");
                        });


                        //2
                      }else if(data_list[0]["category_sub_cat"][i]["name"]=="Contraception"){

                        reproHelper.save({
                          'name': data_list[0]["name"],
                          "contraceptionintroduction":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                          "methods":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                          "condomswork":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                          "injectable":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                          "oralpill":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                          "iucds":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                          "implants":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                          "emergency":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                          "contraceptionvideo":data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],

                          //Null fields
                          "boyfriend":null,
                          "night":null,
                          "casual":null,
                          "sponsor":null,
                          "dyn1":null,
                          "sponsorvideo":null,

                          "pregnancydyn":null,
                          "pregnancycauses":null,
                          "pregnancysigns":null,
                          "pregnancytest":null,
                          "prenatalcare":null,
                          "antinetalcare":null,
                          "postnatal":null,
                          "pregnancynutrition":null,
                          "pregnancydanger":null,

                          "stiintroduction":null,
                          "riskfactors":null,
                          "stitypes":null,
                          "stisigns":null,
                          "commonstisigns":null,
                          "treatment":null,
                          "protectiontips":null,
                          "facts":null,
                          "myths":null,
                          'stisharm':null,
                          'hivsti':null,

                          'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                        }).then((value){
                          print("Contraception Saved successfully");
                        });

                        //3
                      }else if(data_list[0]["category_sub_cat"][i]["name"]=="Campus Pregnancy"){

                        reproHelper.save({
                          'name': data_list[0]["name"],
                          "pregnancydyn":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                          "pregnancycauses":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                          "pregnancysigns":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                          "pregnancytest":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                          "prenatalcare":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                          "antinetalcare":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                          "postnatal":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                          "pregnancynutrition":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                          "pregnancydanger":data_list[0]["category_sub_cat"][2]["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]['content'],

                          //Null values
                          "contraceptionintroduction":null,
                          "methods":null,
                          "condomswork":null,
                          "injectable":null,
                          "oralpill":null,
                          "iucds":null,
                          "implants":null,
                          "emergency":null,
                          "contraceptionvideo":null,

                          "boyfriend":null,
                          "night":null,
                          "casual":null,
                          "sponsor":null,
                          "dyn1":null,
                          "sponsorvideo":null,

                          "stiintroduction":null,
                          "riskfactors":null,
                          "stitypes":null,
                          "stisigns":null,
                          "commonstisigns":null,
                          "treatment":null,
                          "protectiontips":null,
                          "facts":null,
                          "myths":null,
                          'stisharm':null,
                          'hivsti':null,

                          'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                        }).then((value){
                          print("Campus Pregnancy Saved successfully");
                        });

                        //4
                      }else if(data_list[0]["category_sub_cat"][i]["name"]=="Sexually Transmitted Infections"){
                        reproHelper.save({
                          'name': data_list[0]["name"],
                          "stiintroduction":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                          "riskfactors":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                          "stitypes":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                          "stisigns":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                          "commonstisigns":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                          "treatment":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                          "protectiontips":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                          "facts":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]['content'],
                          "myths":data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][9]["sub_sub_cat_content"][0]['content'],
                          'stisharm':data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][10]["sub_sub_cat_content"][0]['content'],
                          'hivsti':data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"][11]["sub_sub_cat_content"][0]['content'],

                          "contraceptionintroduction":null,
                          "methods":null,
                          "condomswork":null,
                          "injectable":null,
                          "oralpill":null,
                          "iucds":null,
                          "implants":null,
                          "emergency":null,
                          "contraceptionvideo":null,

                          "pregnancydyn":null,
                          "pregnancycauses":null,
                          "pregnancysigns":null,
                          "pregnancytest":null,
                          "prenatalcare":null,
                          "antinetalcare":null,
                          "postnatal":null,
                          "pregnancynutrition":null,
                          "pregnancydanger":null,

                          "boyfriend":null,
                          "night":null,
                          "casual":null,
                          "sponsor":null,
                          "dyn1":null,
                          "sponsorvideo":null,

                          'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                        }).then((value){
                          print("Saved successfully");
                          hivHelper.save({
                            'name': data_list[1]["name"],
                            "kenyahiv":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                            "definition":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                            "hivsymptoms":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                            "transmissionmodes":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                            "nottransmitted":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                            "hivmyths":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                            "hivprevention":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                            "mothertochild":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                            "hivstigma":data_list[1]["category_sub_cat"][0]["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]['content'],
                            'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                          }).then((value){
                            print("Saved HIV Data successfully");
                          }).then((value){

                            safetyHelper.save({
                              'name': data_list[2]["name"],
                              "safedating":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                              "datingrules":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                              "formen":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                              "forladies":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                              //"datingtips":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                              //"cybercrimes":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                              "safetytips":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                              "campussafetytips":data_list[2]["category_sub_cat"][4]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                              "campussafety":data_list[2]["category_sub_cat"][4]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],

                              "cybercrimesintro":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                              "cybercrimestips":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                              "cybercrimestypes":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                              "cyberlaws":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                              "socialmediabenefits":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                              "socialmediapitfalls":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                              "socialmediarules":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                              "socialmediasafety":data_list[2]["category_sub_cat"][2]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                              "gbvintro":data_list[2]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                              "prominentplaces":data_list[2]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                              "protectyourself":data_list[2]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                              "gbveffects":data_list[2]["category_sub_cat"][1]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                              "gettinghelp":data_list[2]["category_sub_cat"][1]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],

                              'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                            }).then((value){
                              print("Saved Safety Data successfully");
                              drugsHelper.save({
                                'name': data_list[3]["name"],
                                "alcoholintroduction":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                "alcoholismsigns":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                "associatedhealthissues":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                "alcoholismtreatment":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                                "alcoholismhelp":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                "alcoholhelpcontacts":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                "alcoholvideo":data_list[3]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],

                                "heroineintro":data_list[3]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                "heroineeffects":data_list[3]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                "heroineinjection":data_list[3]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                "heroinerecovery":data_list[3]["category_sub_cat"][1]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                "heroinefurtherhelp":data_list[3]["category_sub_cat"][1]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                "weedintro":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                "weeddyn":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                "weedmyths":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                "weedfacts":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                "quitweed":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                "weednote":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                "weedfaq":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                                "weedhelp":data_list[3]["category_sub_cat"][2]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],

                                'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                              }).then((value){
                                print("Saved Drugs Data successfully");
                                mentalHelper.save({
                                  'name': data_list[4]["name"],
                                  "mentaldef":data_list[4]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                  "mentalilldef":data_list[4]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                  "riskfactors":data_list[4]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                  "disorders":data_list[4]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                                  "suicideprevention":data_list[4]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                  "suicidehelp":data_list[4]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                  "suicidevideo":data_list[4]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],

                                  "eatingdisordersinto":data_list[4]["category_sub_cat"][2]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                  "anorexia":data_list[4]["category_sub_cat"][2]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                  "bulimia":data_list[4]["category_sub_cat"][2]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                  "biengeeating":data_list[4]["category_sub_cat"][2]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                  "eatinghelp":data_list[4]["category_sub_cat"][2]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                  "mentalhelpintro":data_list[4]["category_sub_cat"][3]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                  "psychotherapy":data_list[4]["category_sub_cat"][3]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                  "medication":data_list[4]["category_sub_cat"][3]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                  "selfhelp":data_list[4]["category_sub_cat"][3]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                                  'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                                }).then((value){
                                  print("Saved Mental Data successfully");
                                  healthHelper.save({
                                    'name': data_list[5]["name"],
                                    "noncommunicableintro":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                    "keyriskfactors":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                    "poorlifestyles":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                    "healthylifestyles":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                                    "weightobesity":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                    "weightmanagement":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                    "weightmanagementrecons":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                    "weightmanagementhelp":data_list[5]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],

                                    "nutritionintro":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                    "foodproduction":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                    "foodconsumption":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                    "nutrientutilization":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                    "posthavest":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                    "physicalinactivity":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                    "nutrientsources":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                                    "nutritionandpregnancy":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                                    "nutritionandhiv":data_list[5]["category_sub_cat"][1]["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]['content'],

                                    "hygieneintro":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                    "hygieneimportance":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                    "goodhabits":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                    "emergencyplanning":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                    "selfmaintainace":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                    "offensivehabits":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                    "support":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                                    "remember":data_list[5]["category_sub_cat"][2]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
                                    "physicalintro":data_list[5]["category_sub_cat"][3]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                    "benefits":data_list[5]["category_sub_cat"][3]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],

                                    'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                                  }).then((value){
                                    print("Saved Health Data successfully");
                                    othersHelper.save({
                                      'name': data_list[6]["name"],
                                      "introduction":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                      "seventips":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
                                      "savingmoney":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                      "takeaction":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],

                                      "moneysavingtips":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                      "earnextracoin":data_list[6]["category_sub_cat"][0]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                      "gratuationjob":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
                                      "careerresourses":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],

                                      "internships":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
                                      "cvletter":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
                                      "professionaljobs":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                                      "alumni":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
                                      "recentgratuates":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                                      "createopportunities":data_list[6]["category_sub_cat"][1]["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],

                                      'created_at':DateTime.now().millisecondsSinceEpoch.toString()

                                    }).then((value){
                                      var documentReference = Firestore.instance
                                          .collection('Users')
                                          .document(useruid[0]);
                                      Firestore.instance.runTransaction((transaction) async {
                                        await transaction.update(
                                          documentReference,
                                          {
                                            'synced':true
                                          },
                                        );
                                      }).then((value){

                                        PersistedStateBuilder(

                                          builder: (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
                                            snapshot.data["synced"]=true;
                                            return SizedBox(height: 0,width: 0,);
                                          },

                                        );

                                        Flushbar(
                                          title: "Success",
                                          message: "Data Updated Successfully",
                                          icon: Icon(Icons.done_all,color: Colors.white,size: 30,),
                                          duration: Duration(seconds: 3),
                                          isDismissible: false,
                                          backgroundColor: Colors.green,
                                        )..show(context);
                                        //print("Saved Others Data successfully");
                                      });

                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      }
                    }
                  }
                });
              });
            });
          });
        });
      });
    });*/
    ///deleting ends here

    return "nothing";
  }

  /*Future<String> getContent(bool synced,AsyncSnapshot snapshot) async{*/
  Future<String> getContent(synced) async {
    Navigator.of(context, rootNavigator: true).pop();

    final SharedPreferences prefs = await _prefs;
    //prefs.setInt('savedNumber', 1);
    final synced = prefs.getInt('synced') ?? 0;
    print("Synced" + synced.toString());

    print("Stating..............");
    Flushbar(
      title: "Syncing",
      message: "Syncing data please wait",
      icon: Icon(
        Icons.done_all,
        color: Colors.white,
        size: 30,
      ),
      duration: Duration(seconds: 3),
      isDismissible: false,
      backgroundColor: Colors.pink,
    )..show(context);

    for (var k in categories) {
      http.Response response = await http.get(
          'http://rada.uonbi.ac.ke/radaweb/categories/get/$k',
          headers: {"Accept": "application/json"});

      if (response.body ==
          "[ERROR:flutter/lib/ui/ui_dart_state.cc(157)] Unhandled Exception: SocketException: OS Error: Connection timed out, errno = 110, address = rada.uonbi.ac.ke, port = 40817") {
        setState(() {
          showSpinner = false;
        });
        print("Connection timed out");
      }

      var converted = await json.decode(response.body);
      for (var i = 0; i < converted.length; i++) {
        data = converted[i];
        data_list.add(data);
      }
    }

    reproHelper.save({
      'name': data_list[0]["name"],
      "boyfriend": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"]
          [1]["sub_sub_cat_content"][0]['content'],
      "night": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][2]
          ["sub_sub_cat_content"][0]['content'],
      "casual": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][3]
          ["sub_sub_cat_content"][0]['content'],
      "sponsor": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][4]
          ["sub_sub_cat_content"][0]['content'],
      "dyn1": data_list[0]["category_sub_cat"][0]["sub_category_sub_cat"][0]
          ["sub_sub_cat_content"][0]['content'],
      "sponsorvideo": data_list[0]["category_sub_cat"][0]
          ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],

      //Null values
      "contraceptionintroduction": null,
      "methods": null,
      "condomswork": null,
      "injectable": null,
      "oralpill": null,
      "iucds": null,
      "implants": null,
      "emergency": null,
      "contraceptionvideo": null,

      "pregnancydyn": null,
      "pregnancycauses": null,
      "pregnancysigns": null,
      "pregnancytest": null,
      "prenatalcare": null,
      "antinetalcare": null,
      "postnatal": null,
      "pregnancynutrition": null,
      "pregnancydanger": null,

      "stiintroduction": null,
      "riskfactors": null,
      "stitypes": null,
      "stisigns": null,
      "commonstisigns": null,
      "treatment": null,
      "protectiontips": null,
      "facts": null,
      "myths": null,
      'stisharm': null,
      'hivsti': null,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      print("Saved successfully");
      reproHelper.save({
        'name': data_list[0]["name"],
        "contraceptionintroduction": data_list[0]["category_sub_cat"][1]
            ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
        "methods": data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"]
            [1]["sub_sub_cat_content"][0]['content'],
        "condomswork": data_list[0]["category_sub_cat"][1]
            ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
        "injectable": data_list[0]["category_sub_cat"][1]
            ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
        "oralpill": data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"]
            [4]["sub_sub_cat_content"][0]['content'],
        "iucds": data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"][5]
            ["sub_sub_cat_content"][0]['content'],
        "implants": data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"]
            [6]["sub_sub_cat_content"][0]['content'],
        "emergency": data_list[0]["category_sub_cat"][1]["sub_category_sub_cat"]
            [7]["sub_sub_cat_content"][0]['content'],
        "contraceptionvideo": data_list[0]["category_sub_cat"][1]
            ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],

        //Null fields
        "boyfriend": null,
        "night": null,
        "casual": null,
        "sponsor": null,
        "dyn1": null,
        "sponsorvideo": null,

        "pregnancydyn": null,
        "pregnancycauses": null,
        "pregnancysigns": null,
        "pregnancytest": null,
        "prenatalcare": null,
        "antinetalcare": null,
        "postnatal": null,
        "pregnancynutrition": null,
        "pregnancydanger": null,

        "stiintroduction": null,
        "riskfactors": null,
        "stitypes": null,
        "stisigns": null,
        "commonstisigns": null,
        "treatment": null,
        "protectiontips": null,
        "facts": null,
        "myths": null,
        'stisharm': null,
        'hivsti': null,

        'created_at': DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) {
        print("Contraception Saved successfully");
        reproHelper.save({
          'name': data_list[0]["name"],
          "pregnancydyn": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]['content'],
          "pregnancycauses": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]['content'],
          "pregnancysigns": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]['content'],
          "pregnancytest": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]['content'],
          "prenatalcare": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
          "antinetalcare": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]['content'],
          "postnatal": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
          "pregnancynutrition": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]['content'],
          "pregnancydanger": data_list[0]["category_sub_cat"][2]
              ["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]['content'],

          //Null values
          "contraceptionintroduction": null,
          "methods": null,
          "condomswork": null,
          "injectable": null,
          "oralpill": null,
          "iucds": null,
          "implants": null,
          "emergency": null,
          "contraceptionvideo": null,

          "boyfriend": null,
          "night": null,
          "casual": null,
          "sponsor": null,
          "dyn1": null,
          "sponsorvideo": null,

          "stiintroduction": null,
          "riskfactors": null,
          "stitypes": null,
          "stisigns": null,
          "commonstisigns": null,
          "treatment": null,
          "protectiontips": null,
          "facts": null,
          "myths": null,
          'stisharm': null,
          'hivsti': null,

          'created_at': DateTime.now().millisecondsSinceEpoch.toString()
        }).then((value) {
          print("Campus Pregnancy Saved successfully");
          reproHelper.save({
            'name': data_list[0]["name"],
            "stiintroduction": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                ['content'],
            "riskfactors": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                ['content'],
            "stitypes": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                ['content'],
            "stisigns": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                ['content'],
            "commonstisigns": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                ['content'],
            "treatment": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                ['content'],
            "protectiontips": data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                ['content'],
            "facts": data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"]
                [8]["sub_sub_cat_content"][0]['content'],
            "myths": data_list[0]["category_sub_cat"][3]["sub_category_sub_cat"]
                [9]["sub_sub_cat_content"][0]['content'],
            'stisharm': data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][10]["sub_sub_cat_content"][0]
                ['content'],
            'hivsti': data_list[0]["category_sub_cat"][3]
                    ["sub_category_sub_cat"][11]["sub_sub_cat_content"][0]
                ['content'],
            "contraceptionintroduction": null,
            "methods": null,
            "condomswork": null,
            "injectable": null,
            "oralpill": null,
            "iucds": null,
            "implants": null,
            "emergency": null,
            "contraceptionvideo": null,
            "pregnancydyn": null,
            "pregnancycauses": null,
            "pregnancysigns": null,
            "pregnancytest": null,
            "prenatalcare": null,
            "antinetalcare": null,
            "postnatal": null,
            "pregnancynutrition": null,
            "pregnancydanger": null,
            "boyfriend": null,
            "night": null,
            "casual": null,
            "sponsor": null,
            "dyn1": null,
            "sponsorvideo": null,
            'created_at': DateTime.now().millisecondsSinceEpoch.toString()
          }).then((value) {
            print("Saved successfully");
            hivHelper.save({
              'name': data_list[1]["name"],
              "kenyahiv": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                  ['content'],
              "definition": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                  ['content'],
              "hivsymptoms": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                  ['content'],
              "transmissionmodes": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                  ['content'],
              "nottransmitted": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                  ['content'],
              "hivmyths": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                  ['content'],
              "hivprevention": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                  ['content'],
              "mothertochild": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                  ['content'],
              "hivstigma": data_list[1]["category_sub_cat"][0]
                      ["sub_category_sub_cat"][8]["sub_sub_cat_content"][0]
                  ['content'],
              'created_at': DateTime.now().millisecondsSinceEpoch.toString()
            }).then((value) {
              print("Saved HIV Data successfully");
              safetyHelper.save({
                'name': data_list[2]["name"],
                "safedating": data_list[2]["category_sub_cat"][0]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],
                "datingrules": data_list[2]["category_sub_cat"][0]
                        ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                    ['content'],
                "formen": data_list[2]["category_sub_cat"][0]
                        ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                    ['content'],
                "forladies": data_list[2]["category_sub_cat"][0]
                        ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                    ['content'],
                //"datingtips":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]['content'],
                //"cybercrimes":data_list[2]["category_sub_cat"][0]["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]['content'],
                "safetytips": data_list[2]["category_sub_cat"][0]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],
                "campussafetytips": data_list[2]["category_sub_cat"][4]
                        ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                    ['content'],
                "campussafety": data_list[2]["category_sub_cat"][4]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],

                "cybercrimesintro": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],
                "cybercrimestips": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                    ['content'],
                "cybercrimestypes": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                    ['content'],
                "cyberlaws": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                    ['content'],
                "socialmediabenefits": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                    ['content'],
                "socialmediapitfalls": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                    ['content'],
                "socialmediarules": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                    ['content'],
                "socialmediasafety": data_list[2]["category_sub_cat"][2]
                        ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                    ['content'],

                "gbvintro": data_list[2]["category_sub_cat"][1]
                        ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                    ['content'],
                "prominentplaces": data_list[2]["category_sub_cat"][1]
                        ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                    ['content'],
                "protectyourself": data_list[2]["category_sub_cat"][1]
                        ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                    ['content'],
                "gbveffects": data_list[2]["category_sub_cat"][1]
                        ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                    ['content'],
                "gettinghelp": data_list[2]["category_sub_cat"][1]
                        ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                    ['content'],

                'created_at': DateTime.now().millisecondsSinceEpoch.toString()
              }).then((value) {
                print("Saved Safety Data successfully");
                drugsHelper.save({
                  'name': data_list[3]["name"],
                  "alcoholintroduction": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                      ['content'],
                  "alcoholismsigns": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                      ['content'],
                  "associatedhealthissues": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                      ['content'],
                  "alcoholismtreatment": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                      ['content'],
                  "alcoholismhelp": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                      ['content'],
                  "alcoholhelpcontacts": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                      ['content'],
                  "alcoholvideo": data_list[3]["category_sub_cat"][0]
                          ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                      ['content'],
                  "heroineintro": data_list[3]["category_sub_cat"][1]
                          ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                      ['content'],
                  "heroineeffects": data_list[3]["category_sub_cat"][1]
                          ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                      ['content'],
                  "heroineinjection": data_list[3]["category_sub_cat"][1]
                          ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                      ['content'],
                  "heroinerecovery": data_list[3]["category_sub_cat"][1]
                          ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                      ['content'],
                  "heroinefurtherhelp": data_list[3]["category_sub_cat"][1]
                          ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                      ['content'],
                  "weedintro": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][0]["sub_sub_cat_content"][0]
                      ['content'],
                  "weeddyn": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][1]["sub_sub_cat_content"][0]
                      ['content'],
                  "weedmyths": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][2]["sub_sub_cat_content"][0]
                      ['content'],
                  "weedfacts": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][3]["sub_sub_cat_content"][0]
                      ['content'],
                  "quitweed": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][4]["sub_sub_cat_content"][0]
                      ['content'],
                  "weednote": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][5]["sub_sub_cat_content"][0]
                      ['content'],
                  "weedfaq": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][6]["sub_sub_cat_content"][0]
                      ['content'],
                  "weedhelp": data_list[3]["category_sub_cat"][2]
                          ["sub_category_sub_cat"][7]["sub_sub_cat_content"][0]
                      ['content'],
                  'created_at': DateTime.now().millisecondsSinceEpoch.toString()
                }).then((value) {
                  print("Saved Drugs Data successfully");
                  print("Looking for " +
                      data_list[3]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                          [0]['content']);
                  mentalHelper.save({
                    'name': data_list[4]["name"],
                    "mentaldef": data_list[4]["category_sub_cat"][0]
                            ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                        [0]['content'],
                    "mentalilldef": data_list[4]["category_sub_cat"][0]
                            ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                        [0]['content'],
                    "riskfactors": data_list[4]["category_sub_cat"][0]
                            ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                        [0]['content'],
                    "disorders": data_list[4]["category_sub_cat"][0]
                            ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                        [0]['content'],
                    "suicideprevention": data_list[4]["category_sub_cat"][1]
                            ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                        [0]['content'],
                    "suicidehelp": data_list[4]["category_sub_cat"][1]
                            ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                        [0]['content'],
                    "suicidevideo": data_list[4]["category_sub_cat"][1]
                            ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                        [0]['content'],
                    "eatingdisordersinto": data_list[4]["category_sub_cat"][2]
                            ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                        [0]['content'],
                    "anorexia": data_list[4]["category_sub_cat"][2]
                            ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                        [0]['content'],
                    "bulimia": data_list[4]["category_sub_cat"][2]
                            ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                        [0]['content'],
                    "biengeeating": data_list[4]["category_sub_cat"][2]
                            ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                        [0]['content'],
                    "eatinghelp": data_list[4]["category_sub_cat"][2]
                            ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                        [0]['content'],
                    "mentalhelpintro": data_list[4]["category_sub_cat"][3]
                            ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                        [0]['content'],
                    "psychotherapy": data_list[4]["category_sub_cat"][3]
                            ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                        [0]['content'],
                    "medication": data_list[4]["category_sub_cat"][3]
                            ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                        [0]['content'],
                    "selfhelp": data_list[4]["category_sub_cat"][3]
                            ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                        [0]['content'],
                    'created_at':
                        DateTime.now().millisecondsSinceEpoch.toString()
                  }).then((value) {
                    print("Saved Mental Data successfully");
                    healthHelper.save({
                      'name': data_list[5]["name"],
                      "noncommunicableintro": data_list[5]["category_sub_cat"]
                              [0]["sub_category_sub_cat"][0]
                          ["sub_sub_cat_content"][0]['content'],
                      "keyriskfactors": data_list[5]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                          [0]['content'],
                      "poorlifestyles": data_list[5]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                          [0]['content'],
                      "healthylifestyles": data_list[5]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                          [0]['content'],
                      "weightobesity": data_list[5]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                          [0]['content'],
                      "weightmanagement": data_list[5]["category_sub_cat"][0]
                              ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                          [0]['content'],
                      "weightmanagementrecons": data_list[5]["category_sub_cat"]
                              [0]["sub_category_sub_cat"][5]
                          ["sub_sub_cat_content"][0]['content'],
                      "weightmanagementhelp": data_list[5]["category_sub_cat"]
                              [0]["sub_category_sub_cat"][6]
                          ["sub_sub_cat_content"][0]['content'],
                      "nutritionintro": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                          [0]['content'],
                      "foodproduction": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                          [0]['content'],
                      "foodconsumption": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                          [0]['content'],
                      "nutrientutilization": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                          [0]['content'],
                      "posthavest": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                          [0]['content'],
                      "physicalinactivity": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][5]["sub_sub_cat_content"]
                          [0]['content'],
                      "nutrientsources": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][6]["sub_sub_cat_content"]
                          [0]['content'],
                      "nutritionandpregnancy": data_list[5]["category_sub_cat"]
                              [1]["sub_category_sub_cat"][7]
                          ["sub_sub_cat_content"][0]['content'],
                      "nutritionandhiv": data_list[5]["category_sub_cat"][1]
                              ["sub_category_sub_cat"][8]["sub_sub_cat_content"]
                          [0]['content'],
                      "hygieneintro": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                          [0]['content'],
                      "hygieneimportance": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                          [0]['content'],
                      "goodhabits": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][2]["sub_sub_cat_content"]
                          [0]['content'],
                      "emergencyplanning": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][3]["sub_sub_cat_content"]
                          [0]['content'],
                      "selfmaintainace": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][4]["sub_sub_cat_content"]
                          [0]['content'],
                      "offensivehabits": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][5]["sub_sub_cat_content"]
                          [0]['content'],
                      "support": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][6]["sub_sub_cat_content"]
                          [0]['content'],
                      "remember": data_list[5]["category_sub_cat"][2]
                              ["sub_category_sub_cat"][7]["sub_sub_cat_content"]
                          [0]['content'],
                      "physicalintro": data_list[5]["category_sub_cat"][3]
                              ["sub_category_sub_cat"][0]["sub_sub_cat_content"]
                          [0]['content'],
                      "benefits": data_list[5]["category_sub_cat"][3]
                              ["sub_category_sub_cat"][1]["sub_sub_cat_content"]
                          [0]['content'],
                      'created_at':
                          DateTime.now().millisecondsSinceEpoch.toString()
                    }).then((value) {
                      print("Saved Health Data successfully");
                      othersHelper.save({
                        'name': data_list[6]["name"],
                        "introduction": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][0]
                            ["sub_sub_cat_content"][0]['content'],
                        "seventips": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][1]
                            ["sub_sub_cat_content"][0]['content'],
                        "savingmoney": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][2]
                            ["sub_sub_cat_content"][0]['content'],
                        "takeaction": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][3]
                            ["sub_sub_cat_content"][0]['content'],
                        "moneysavingtips": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][4]
                            ["sub_sub_cat_content"][0]['content'],
                        "earnextracoin": data_list[6]["category_sub_cat"][0]
                                ["sub_category_sub_cat"][5]
                            ["sub_sub_cat_content"][0]['content'],
                        "gratuationjob": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][0]
                            ["sub_sub_cat_content"][0]['content'],
                        "careerresourses": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][1]
                            ["sub_sub_cat_content"][0]['content'],
                        "internships": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][2]
                            ["sub_sub_cat_content"][0]['content'],
                        "cvletter": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][3]
                            ["sub_sub_cat_content"][0]['content'],
                        "professionaljobs": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][4]
                            ["sub_sub_cat_content"][0]['content'],
                        "alumni": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][5]
                            ["sub_sub_cat_content"][0]['content'],
                        "recentgratuates": data_list[6]["category_sub_cat"][1]
                                ["sub_category_sub_cat"][6]
                            ["sub_sub_cat_content"][0]['content'],
                        "createopportunities": data_list[6]["category_sub_cat"]
                                [1]["sub_category_sub_cat"][7]
                            ["sub_sub_cat_content"][0]['content'],
                        'created_at':
                            DateTime.now().millisecondsSinceEpoch.toString()
                      }).then((value) {
                        prefs.setInt('synced', 1);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => Information(
                                      synced: true,
                                    )));

                        setState(() {});

                        /*PersistedAppState(
                                child: PersistedStateBuilder(

                                  builder: (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
                                    setState(() {
                                      snapshot.data["synced"]=true;
                                    });
                                    return SizedBox(height: 0,width: 0,);
                                  },

                                ),
                              );*/

                        Flushbar(
                          title: "Success",
                          message: "Fetched Data Successfully",
                          icon: Icon(
                            Icons.done_all,
                            color: Colors.white,
                            size: 30,
                          ),
                          duration: Duration(seconds: 3),
                          isDismissible: false,
                          backgroundColor: Colors.green,
                        )..show(context);
                      });
                    });
                  });
                });
              });
            });
            //New Storage End
          });
        });
      });
    });

    return "nothing";
  }

  Widget listCard(img, name, id, itemkey, synced) {
    return PersistedAppState(child: PersistedStateBuilder(
        builder: (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
      return GestureDetector(
        onTap: () {
          print("Pressed");
          //print(snapshot.data["synced"]);
          /*if(widget.synced==false){*/
          /*if(snapshot.data["synced"]==false){*/
          if (synced == 0 || synced == null) {
            _showMyDialog(itemkey, synced);

            //show dialog
            /*showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('Sync Data'),
                        insetAnimationDuration: Duration(milliseconds: 1000),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              //Text('Fetch Data.'),
                              Text('Syncing is required the first time to fetch data',style: TextStyle(fontFamily: 'Raleway-regular',fontWeight: FontWeight.bold,fontSize: 16),),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: RaisedButton(
                              color: Colors.green,
                              child: Text('Sync',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                getContent(synced,snapshot);

                                //Getting Content Start



                                //Getting Content End

                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: RaisedButton(
                              color: Colors.orange,
                              child: Text('Not now',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );*/
            //show Dialog End

          } else if (synced == 1) {
            if (itemkey == "3") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ContentPage(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "4") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => HivContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "5") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => SafetyContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "6") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => DrugsContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "7") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => MentalContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "8") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => HealthContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            } else if (itemkey == "9") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => OthersContent(
                            id: id,
                            name: name,
                            image: img,
                            itemkey: itemkey,
                          )));
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 5, left: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 150,
              width: 140,
              color: Colors.grey[300],
              child: Stack(
                children: <Widget>[
                  /*Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 170,
                  ),*/

                  CachedNetworkImage(
                      imageUrl: img,
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
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black45, Colors.brown[400]],
                              begin: FractionalOffset(0, 0),
                              end: FractionalOffset(0, 1),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 5, top: 2),
                                child: Text(
                                  name,
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}
