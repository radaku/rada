import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:radauon/model/healthmodel.dart';
import 'package:radauon/utils/health_helper.dart';
import 'package:radauon/utils/mental_helper.dart';
import 'package:readmore/readmore.dart';

class HealthContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  HealthContent(
      {Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _HealthContentState createState() => _HealthContentState();
}

class _HealthContentState extends State<HealthContent> {
  Map data;
  List data_list = [];

  MentalHelper mentalHelper;
  HealthHelper healthHelper;

  var width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mentalHelper = MentalHelper();
    healthHelper = HealthHelper();
  }

  Future getProjectDetails() async {
    List<HealthModel> messages = await healthHelper.getMessages();
    return messages;
  }

  Widget communicableItem(
      String icon, String title, String content, String image) {
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
                      borderRadius: BorderRadius.circular(5),
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

  Widget hygieneItem(String icon, String title, String content, String image) {
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
                      borderRadius: BorderRadius.circular(5),
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

  Widget nutritionItem(
      String icon, String title, String content, String image) {
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
                      borderRadius: BorderRadius.circular(5),
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
                HealthModel project = projectSnap.data[0];
                //healthHelper.delete(index);

                if (widget.itemkey == "8") {
                  var data = [
                    {
                      "title": "Introduction",
                      "content": project.noncommunicableintro
                    },
                    {
                      "title": "Key Risk Factors",
                      "content": project.keyriskfactors
                    },
                    {
                      "title": "Youth and Poor Lifestyles",
                      "content": project.poorlifestyles
                    },
                    {
                      "title": "Healthy Lifestyles",
                      "content": project.healthylifestyles
                    },
                    {
                      "title": "Weight and Obesity Management",
                      "content": project.weightobesity
                    },
                    {
                      "title": "Weight Management Recommendations",
                      "content": project.weightmanagementrecons
                    },
                    {
                      "title": "Weight Management Help",
                      "content": project.weightmanagementhelp
                    },

                    {
                      "title": "Nutrition Introduction",
                      "content": project.nutritionintro
                    },
                    {
                      "title": "Food Production Process",
                      "content": project.foodproduction
                    },
                    {
                      "title": "Food Consumption",
                      "content": project.foodconsumption
                    },
                    {
                      "title": "Nutrients Utilization",
                      "content": project.nutrientutilization
                    },
                    {
                      "title": "Food Post Harvest",
                      "content": project.posthavest
                    },
                    {
                      "title": "Nutrition and Physical Inactivity",
                      "content": project.physicalinactivity
                    },
                    {
                      "title": "Nutrient Sources",
                      "content": project.nutrientsources
                    },
                    {
                      "title": "Nutrition and Pregnancy",
                      "content": project.nutritionandpregnancy
                    },
                    {
                      "title": "Nutrition, HIV, Pregnancy",
                      "content": project.nutritionandhiv
                    },

                    //cont
                    {
                      "title": "Personal Hygiene Introduction",
                      "content": project.hygieneintro
                    },
                    {
                      "title": "Hygiene Importance",
                      "content": project.hygieneimportance
                    },
                    {"title": "Good Habits", "content": project.goodhabits},
                    {
                      "title": "Emergency Planning",
                      "content": project.emergencyplanning
                    },
                    {
                      "title": "Self-Care Maintenance",
                      "content": project.selfmaintainace
                    },
                    {
                      "title": "Offensive Habits",
                      "content": project.offensivehabits
                    },
                    {"title": "Support", "content": project.support},
                    {"title": "Remember", "content": project.remember},

                    {
                      "title": "Benefits Of Physical Activities",
                      "content": project.benefits
                    },
                  ];
                  if (widget.name == "Non Communicable...") {
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
                                            "assets/images/arrow.jpg"),
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
                                        "Non Communicable Diseases",
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
                                        data[0]["title"].toString(),
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
                                      data[0]["content"].toString(),
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

                          communicableItem(
                              "assets/images/arrow.png",
                              data[1]["title"],
                              data[1]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/health3.jpeg"),
                          communicableItem("assets/images/couple.png",
                              data[2]["title"], data[2]["content"], "null"),

                          communicableItem("assets/images/couple.png",
                              data[3]["title"], data[3]["content"], "null"),
                          communicableItem(
                              "assets/images/couple.png",
                              data[4]["title"],
                              data[4]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/health1.jpeg"),
                          communicableItem("assets/images/couple.png",
                              data[5]["title"], data[5]["content"], "null"),

                          communicableItem(
                              "assets/images/couple.png",
                              data[6]["title"],
                              data[6]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/health2.jpeg"),
                        ],
                      ),
                    );
                  } else if (widget.name == "Nutrition") {
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
                                        "Nutrition",
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
                                        data[7]["title"].toString(),
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
                                      data[7]["content"].toString(),
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

                          nutritionItem(
                              "assets/images/arrow.png",
                              data[8]["title"],
                              data[8]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition1.jpg"),

                          nutritionItem(
                              "assets/images/arrow.png",
                              data[9]["title"],
                              data[9]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition2.jpg"),
                          nutritionItem(
                              "assets/images/arrow.png",
                              data[10]["title"],
                              data[10]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition3.jpg"),
                          nutritionItem(
                              "assets/images/arrow.png",
                              data[11]["title"],
                              data[11]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition6.jpg"),

                          nutritionItem(
                              "assets/images/arrow.png",
                              data[12]["title"],
                              data[12]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition7.jpg"),
                          nutritionItem(
                              "assets/images/arrow.png",
                              data[13]["title"],
                              data[13]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/nutrition8.jpg"),
                          nutritionItem("assets/images/arrow.png",
                              data[14]["title"], data[14]["content"], "null"),
                          nutritionItem("assets/images/arrow.png",
                              data[15]["title"], data[15]["content"], "null"),
                        ],
                      ),
                    );
                  } else if (widget.name == "Personal Hygiene") {
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
                                        "Personal Hygiene",
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
                                        data[16]["title"].toString(),
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
                                      data[16]["content"].toString(),
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

                          nutritionItem(
                              "assets/images/arrow.png",
                              data[17]["title"],
                              data[17]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/hygiene1.jpg"),

                          nutritionItem(
                              "assets/images/arrow.png",
                              data[18]["title"],
                              data[18]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/hygiene2.jpg"),
                          nutritionItem("assets/images/arrow.png",
                              data[19]["title"], data[19]["content"], "null"),
                          nutritionItem("assets/images/arrow.png",
                              data[20]["title"], data[20]["content"], "null"),

                          nutritionItem("assets/images/arrow.png",
                              data[21]["title"], data[21]["content"], "null"),
                          nutritionItem("assets/images/arrow.png",
                              data[22]["title"], data[22]["content"], "null"),
                          nutritionItem("assets/images/arrow.png",
                              data[23]["title"], data[23]["content"], "null"),
                        ],
                      ),
                    );
                  } else if (widget.name == "Physical Activities") {
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
                                        "Physical Activities",
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
                                        data[24]["title"].toString(),
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
                                      data[24]["content"].toString(),
                                      trimLines: 10,
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
