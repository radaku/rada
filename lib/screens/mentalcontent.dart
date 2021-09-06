import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:radauon/model/mentalmodel.dart';
import 'package:radauon/utils/mental_helper.dart';
import 'package:readmore/readmore.dart';

class MentalContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  MentalContent(
      {Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _MentalContentState createState() => _MentalContentState();
}

class _MentalContentState extends State<MentalContent> {
  Map data;
  List data_list = [];

  MentalHelper mentalHelper;

  var width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mentalHelper = MentalHelper();
  }

  Future getProjectDetails() async {
    List<MentalModel> messages = await mentalHelper.getMessages();
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
            appBar:Platform.isIOS?AppBar(
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
            ):SizedBox(height: 0,width: 0,),
            body: FutureBuilder(
          builder: (context, projectSnap) {
            return ListView.builder(
              itemCount: projectSnap.data == null ? 0 : 1,
              itemBuilder: (context, index) {
                MentalModel project = projectSnap.data[0];
                //mentalHelper.delete(index);

                if (widget.itemkey == "7") {
                  var data = [
                    {"title": "Mental Health", "content": project.mentaldef},
                    {
                      "title": "Mental Illness",
                      "content": project.mentalilldef
                    },
                    {"title": "Risk Factors", "content": project.riskfactors},
                    {
                      "title": "Mental Health Disorders",
                      "content": project.disorders
                    },
                    {
                      "title": "Suicide Prevention",
                      "content": project.suicideprevention
                    },
                    {
                      "title": "Getting Help (Suicide)",
                      "content": project.suicidehelp
                    },
                    {
                      "title": "Suicide Counseling Video",
                      "content": project.suicidevideo
                    },
                    {
                      "title": "Eating Disorders",
                      "content": project.eatingdisordersinto
                    },
                    {
                      "title": "Anorexia Nervosa Disorder",
                      "content": project.anorexia
                    },
                    {
                      "title": "Bulimia Nervosa Disorder",
                      "content": project.bulimia
                    },
                    {
                      "title": "Binge Eating Disorder (BED)",
                      "content": project.biengeeating
                    },
                    {
                      "title": "Get Help (Eating Disorders)",
                      "content": project.eatinghelp
                    },
                    {
                      "title": "Mental Health Cont..",
                      "content": project.mentalhelpintro
                    },
                    {
                      "title": "Psychotherapy",
                      "content": project.psychotherapy
                    },
                    {"title": "Medication", "content": project.medication},
                    {"title": "Self-help", "content": project.selfhelp},
                  ];
                  if (widget.name == "Mental Illnesses") {
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
                                            "assets/images/illness.jpg"),
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
                                        "Mental Health",
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
                              "http://rada.uonbi.ac.ke/radaweb/appimages/mental1.jpg"),
                          columnItem(
                              "assets/images/couple.png",
                              data[2]["title"],
                              data[2]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/mental2.jpg"),

                          columnItem(
                              "assets/images/couple.png",
                              data[3]["title"],
                              data[3]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/mental3.jpg"),
                        ],
                      ),
                    );
                  } else if (widget.name == "Suicide") {
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
                                            "assets/images/illness.jpg"),
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
                                        "Suicide",
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

                          columnItem("assets/images/couple.png",
                              data[5]["title"], data[5]["content"], ""),

                          /*columnItem("assets/images/couple.png",
                              data[6]["title"], data[6]["content"], ""),*/
                        ],
                      ),
                    );
                  } else if (widget.name == "Eating disorders") {
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
                                            "assets/images/illness.jpg"),
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
                                        "Eating Disorders",
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

                          columnItem("assets/images/couple.png",
                              data[8]["title"], data[8]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[9]["title"], data[9]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[10]["title"], data[10]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[11]["title"], data[11]["content"], ""),
                        ],
                      ),
                    );
                  } else if (widget.name == "Get Help") {
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
                                            "assets/images/illness.jpg"),
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
                                        "Get Help",
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

                          columnItem("assets/images/couple.png",
                              data[13]["title"], data[13]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[14]["title"], data[14]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[15]["title"], data[15]["content"], ""),
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
                margin: EdgeInsets.only(top: 10),
                height: 170,
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
