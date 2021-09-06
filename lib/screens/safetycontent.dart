import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:radauon/model/safetymodel.dart';
import 'package:radauon/utils/hiv_helper.dart';
import 'package:radauon/utils/safety_helper.dart';
import 'package:readmore/readmore.dart';

class SafetyContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  SafetyContent(
      {Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _SafetyContentState createState() => _SafetyContentState();
}

class _SafetyContentState extends State<SafetyContent> {
  Map data;
  List data_list = [];

  HivHelper hivHelper;
  SafetyHelper safetyHelper;

  var width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hivHelper = HivHelper();
    safetyHelper = SafetyHelper();
  }

  Future getProjectDetails() async {
    List<SafetyModel> messages = await safetyHelper.getMessages();
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
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
            ):SizedBox(
              height: 0,
              width: 0,
            ),
            body: FutureBuilder(
          builder: (context, projectSnap) {
            return ListView.builder(
              itemCount: projectSnap.data == null ? 0 : 1,
              itemBuilder: (context, index) {
                SafetyModel project = projectSnap.data[0];
                //safetyHelper.delete(index);

                if (widget.itemkey == "5") {
                  var data = [
                    {"title": "Safe Dating", "content": project.safedating},
                    {
                      "title": "17 Simple Dating Rules",
                      "content": project.datingrules
                    },
                    {
                      "title": "Tips for Men by Women",
                      "content": project.formen
                    },
                    {
                      "title": "Tips for Ladies by Men",
                      "content": project.forladies
                    },

                    {
                      "title": "Gender Based Violence (GBV)",
                      "content": project.gbvintro
                    },
                    {
                      "title": "GBV Prominent Places",
                      "content": project.prominentplaces
                    },
                    {
                      "title": "Protecting Yourself From GBV",
                      "content": project.protectyourself
                    },
                    {"title": "Effects of GBV", "content": project.gbveffects},
                    {
                      "title": "Getting Help (GBV)",
                      "content": project.gettinghelp
                    },

                    {"title": "Campus Life", "content": project.campussafety},
                    {
                      "title": "Campus Safety Tips",
                      "content": project.campussafetytips
                    },
                    {
                      "title": "General Safety Tips",
                      "content": project.safetytips
                    },

                    //from 6
                    {
                      "title": "Cyber Crimes Introduction",
                      "content": project.cybercrimesintro
                    },
                    {
                      "title": "Types of Cyber Crimes",
                      "content": project.cybercrimestypes
                    },
                    {
                      "title": "Protecting Yourself From Cybercrime",
                      "content": project.cybercrimestips
                    },
                    {
                      "title": "Social Media Safety",
                      "content": project.socialmediasafety
                    },
                    {
                      "title": "Benefits of Social Media",
                      "content": project.socialmediabenefits
                    },
                    {
                      "title": "Social Media Pitfalls",
                      "content": project.socialmediapitfalls
                    },
                    {
                      "title": "Social Media Safety Rules",
                      "content": project.socialmediarules
                    },
                    {
                      "title": "Kenyan Cyber Crime Laws",
                      "content": project.cyberlaws
                    },
                  ];
                  if (widget.name == "Dating") {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            "assets/images/romance.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black54,
                              ),
                              Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                bottom: 25,
                                left: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        */ /*data[index]["title"].toString(),*/ /*
                                        "Dating Tips",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            "assets/images/idea.png",
                                            height: 35,
                                            width: 35,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Neumorphic(
                            margin: EdgeInsets.only(top: 5, right: 5, left: 5),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(2)),
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        data[index]["title"].toString(),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 7),
                                    child: ReadMoreText(
                                      data[index]["content"].toString(),
                                      trimLines: 5,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...read more',
                                      trimExpandedText: ' show less',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Raleway-regular'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Images part

                          columnItem(
                              "assets/images/couple.png",
                              data[1]["title"],
                              data[1]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/dating1.jpg"),
                          columnItem("assets/images/couple.png",
                              data[2]["title"], data[2]["content"], ""),
                          columnItem(
                              "assets/images/couple.png",
                              data[3]["title"],
                              data[3]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/dating2.jpg"),
                        ],
                      ),
                    );
                  }
                  if (widget.name == "GBV") {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            "assets/images/romance.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black54,
                              ),
                              Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                bottom: 25,
                                left: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        */ /*data[index]["title"].toString(),*/ /*
                                        "Gender Based Violence",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            "assets/images/idea.png",
                                            height: 35,
                                            width: 35,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Neumorphic(
                            margin: EdgeInsets.only(top: 5, right: 5, left: 5),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(2)),
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        data[4]["title"].toString(),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 7),
                                    child: ReadMoreText(
                                      data[4]["content"].toString(),
                                      trimLines: 5,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...read more',
                                      trimExpandedText: ' show less',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Raleway-regular'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Images part

                          columnItem(
                              "assets/images/couple.png",
                              data[5]["title"],
                              data[5]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/gbv1.jpg"),
                          columnItem("assets/images/couple.png",
                              data[6]["title"], data[6]["content"], ""),
                          columnItem(
                              "assets/images/couple.png",
                              data[7]["title"],
                              data[7]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/gbv2.jpg"),

                          columnItem("assets/images/couple.png",
                              data[8]["title"], data[8]["content"], ""),
                        ],
                      ),
                    );
                  }
                  if (widget.name == "Cyber Crimes") {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            "assets/images/ccrime.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black54,
                              ),
                              Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                bottom: 25,
                                left: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        */ /*data[index]["title"].toString(),*/ /*
                                        "Cyber Crimes",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            "assets/images/idea.png",
                                            height: 35,
                                            width: 35,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Neumorphic(
                            margin: EdgeInsets.only(top: 5, right: 5, left: 5),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(2)),
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        data[12]["title"].toString(),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 7),
                                    child: ReadMoreText(
                                      data[12]["content"].toString(),
                                      trimLines: 5,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...read more',
                                      trimExpandedText: ' show less',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Raleway-regular'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Images part

                          //columnItem("assets/images/couple.png", data[12]["title"], data[12]["content"]),
                          columnItem("assets/images/couple.png",
                              data[13]["title"], data[13]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[14]["title"], data[14]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[15]["title"], data[15]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[16]["title"], data[16]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[17]["title"], data[17]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[18]["title"], data[18]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[19]["title"], data[19]["content"], ""),

                          /*columnItem("assets/images/couple.png", data[9]["title"], data[9]["content"]),
                              columnItem("assets/images/couple.png", data[10]["title"], data[10]["content"]),
                              columnItem("assets/images/couple.png", data[11]["title"], data[11]["content"]),*/
                        ],
                      ),
                    );
                  }
                  if (widget.name == "Campus Safety") {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            "assets/images/romance.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black54,
                              ),
                              Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.more_horiz,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                              Positioned(
                                bottom: 25,
                                left: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        */ /*data[index]["title"].toString(),*/ /*
                                        "Campus Safety",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            "assets/images/idea.png",
                                            height: 35,
                                            width: 35,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          Neumorphic(
                            margin: EdgeInsets.only(top: 5, right: 5, left: 5),
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(2)),
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        data[9]["title"].toString(),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 7),
                                    child: ReadMoreText(
                                      data[9]["content"].toString(),
                                      trimLines: 5,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...read more',
                                      trimExpandedText: ' show less',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Raleway-regular'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Images part

                          //columnItem("assets/images/couple.png", data[9]["title"], data[9]["content"]),
                          columnItem("assets/images/couple.png",
                              data[10]["title"], data[10]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[11]["title"], data[11]["content"], ""),
                        ],
                      ),
                    );
                  }
                }

                return SizedBox();
              },
            );
          },
          future: getProjectDetails(),
        )));
  }

  Widget columnItem(String image, String title, String content, String main) {
    return Column(
      children: <Widget>[
        main == ""
            ? SizedBox()
            : Container(
                margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  main,
                  fit: BoxFit.cover,
                ),
                /*child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            height: 150,
                            width: 200,
                            color: Colors.red,
                            child: Image.asset(
                              "assets/images/dating.jpg",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ))),
                    SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            height: 150,
                            width: 200,
                            color: Colors.red,
                            child: Image.asset(
                              "assets/images/romance.jpg",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ))),
                    SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            height: 150,
                            width: 200,
                            color: Colors.red,
                            child: Image.asset(
                              "assets/images/dating.jpg",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ))),
                  ],
                ),*/
              ),
        Neumorphic(
          margin: EdgeInsets.only(top: 10, right: 5, left: 5),
          style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(0)),
              depth: 8,
              lightSource: LightSource.topLeft,
              color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Text(
                          title.toString(),
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway-regular'),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 7),
                  child: ReadMoreText(
                    content.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...read more',
                    trimExpandedText: ' show less',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway-regular'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
