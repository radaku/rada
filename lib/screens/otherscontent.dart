import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:radauon/model/othersmodel.dart';
import 'package:radauon/utils/health_helper.dart';
import 'package:radauon/utils/mental_helper.dart';
import 'package:radauon/utils/others_helper.dart';
import 'package:readmore/readmore.dart';

class OthersContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  OthersContent(
      {Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _OthersContentState createState() => _OthersContentState();
}

class _OthersContentState extends State<OthersContent> {
  Map data;
  List data_list = [];

  MentalHelper mentalHelper;
  HealthHelper healthHelper;
  OthersHelper othersHelper;

  var width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mentalHelper = MentalHelper();
    healthHelper = HealthHelper();
    othersHelper = OthersHelper();
  }

  Future getProjectDetails() async {
    List<OthersModel> messages = await othersHelper.getMessages();
    return messages;
  }

  Widget othersItem(String icon, String title, String content, String image) {
    return Column(
      children: <Widget>[
        image == "null"
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Image.network(
                            image,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ))),
                ),
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
                  padding: EdgeInsets.only(left: 0, top: 10),
                  child: ReadMoreText(
                    content.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.green[400],
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...read more',
                    trimExpandedText: ' show less',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway-regular',
                        letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget careerItem(String icon, String title, String content, String image) {
    return Column(
      children: <Widget>[
        image == "null"
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Image.network(
                            image,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ))),
                ),
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
                  padding: EdgeInsets.only(left: 0, top: 10),
                  child: ReadMoreText(
                    content.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.green[400],
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...read more',
                    trimExpandedText: ' show less',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway-regular',
                        letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
                OthersModel project = projectSnap.data[0];
                //othersHelper.delete(index);

                if (widget.itemkey == "9") {
                  var data = [
                    {"title": "Introduction", "content": project.introduction},
                    {
                      "title": "7 Tips To Earn in College",
                      "content": project.seventips
                    },
                    {"title": "Saving Money", "content": project.savingmoney},
                    {"title": "Take Action", "content": project.takeaction},
                    {
                      "title": "Money Saving Tips",
                      "content": project.moneysavingtips
                    },
                    {
                      "title": "Earn Extra Coin",
                      "content": project.earnextracoin
                    },
                    {
                      "title": "Job After Graduation",
                      "content": project.gratuationjob
                    },
                    {
                      "title": "Campus Career Resources",
                      "content": project.careerresourses
                    },
                    {"title": "Internships", "content": project.internships},
                    {
                      "title": "CV and Cover Letter",
                      "content": project.cvletter
                    },
                    {
                      "title": "Professional Job Sites",
                      "content": project.professionaljobs
                    },
                    {"title": "Alumni Association", "content": project.alumni},
                    {
                      "title": "Talk to Recent Graduates",
                      "content": project.recentgratuates
                    },
                    {
                      "title": "Create Opportunities",
                      "content": project.createopportunities
                    },
                  ];
                  if (widget.name == "College Financial...") {
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
                                            "assets/images/communicable.jpg"),
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
                                        "College Financial Management",
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

                          othersItem("assets/images/arrow.png",
                              data[1]["title"], data[1]["content"], "null"),
                          othersItem("assets/images/arrow.png",
                              data[2]["title"], data[2]["content"], "null"),

                          othersItem("assets/images/arrow.png",
                              data[3]["title"], data[3]["content"], "null"),
                          othersItem("assets/images/arrow.png",
                              data[4]["title"], data[4]["content"], "null"),
                          othersItem("assets/images/arrow.png",
                              data[5]["title"], data[5]["content"], "null"),
                        ],
                      ),
                    );
                  } else if (widget.name == "Career") {
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
                                            "assets/images/communicable.jpg"),
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
                                        "Career",
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

                          careerItem("assets/images/arrow.png",
                              data[6]["title"], data[1]["content"], "null"),
                          careerItem("assets/images/couple.png",
                              data[7]["title"], data[2]["content"], "null"),

                          careerItem("assets/images/couple.png",
                              data[8]["title"], data[8]["content"], "null"),
                          careerItem("assets/images/couple.png",
                              data[9]["title"], data[9]["content"], "null"),
                          careerItem("assets/images/couple.png",
                              data[10]["title"], data[10]["content"], "null"),

                          careerItem("assets/images/couple.png",
                              data[11]["title"], data[11]["content"], "null"),
                          careerItem("assets/images/couple.png",
                              data[13]["title"], data[13]["content"], "null"),
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

  Widget columnItem(String image, String title, String content) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: ListView(
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
          ),
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
                    Image.asset(
                      image,
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Wrap(
                      children: <Widget>[
                        Text(
                          title.toString(),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway-regular'),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
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
