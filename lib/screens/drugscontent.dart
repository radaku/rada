import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radauon/model/drugsmodel.dart';
import 'package:radauon/utils/drugs_helper.dart';
import 'package:radauon/utils/hiv_helper.dart';
import 'package:radauon/utils/safety_helper.dart';
import 'package:readmore/readmore.dart';

class DrugsContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  DrugsContent(
      {Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _DrugsContentState createState() => _DrugsContentState();
}

class _DrugsContentState extends State<DrugsContent> {
  Map data;
  List data_list = [];

  HivHelper hivHelper;
  SafetyHelper safetyHelper;
  DrugsHelper drugsHelper;

  var width, height;

  List<String> alcohol = [
    "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol1.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol2.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol3.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol4.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol5.jpg"
  ];

  List<String> weed = [
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed1.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed2.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed3.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed4.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed5.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed6.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed7.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/weed/weed8.jpg"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hivHelper = HivHelper();
    safetyHelper = SafetyHelper();
    drugsHelper = DrugsHelper();
  }

  Future getProjectDetails() async {
    List<DrugsModel> messages = await drugsHelper.getMessages();
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
                DrugsModel project = projectSnap.data[0];
                //drugsHelper.delete(index);

                if (widget.itemkey == "6") {
                  var data = [
                    {
                      "title": "Introduction",
                      "content": project.alcoholintroduction
                    },
                    {
                      "title": "Signs Of Alcoholism",
                      "content": project.alcoholismsigns
                    },
                    {
                      "title": "Alcohol Health Issues",
                      "content": project.associatedhealthissues
                    },
                    {
                      "title": "Alcoholism Treatment",
                      "content": project.alcoholismtreatment
                    },
                    {
                      "title": "Get Help (Alcoholism)",
                      "content": project.alcoholismhelp
                    },
                    {
                      "title": "Alcoholism Help Contacts",
                      "content": project.alcoholhelpcontacts
                    },
                    {
                      "title": "Alcoholism Video",
                      "content": project.alcoholvideo
                    },

                    {"title": "Introduction", "content": project.heroineintro},
                    {
                      "title": "Effects Of Heroine",
                      "content": project.heroineeffects
                    },
                    {
                      "title": "Heroin Injection and HIV",
                      "content": project.heroineinjection
                    },
                    {
                      "title": "Recovery From Heroine",
                      "content": project.heroinerecovery
                    },
                    {
                      "title": "Get Help (Heroine)",
                      "content": project.heroinefurtherhelp
                    },

                    //from 6
                    {"title": "Introduction", "content": project.weedintro},
                    {"title": "Weed Myths", "content": project.weedmyths},
                    {"title": "Weed Facts", "content": project.weedfacts},
                    {"title": "Quiting Weed", "content": project.quitweed},
                    {"title": "Take Note", "content": project.weednote},
                    {"title": "FAQ", "content": project.weedfaq},
                    {"title": "Weed Help", "content": project.weedhelp},
                    {"title": "Did You Know ?", "content": project.weeddyn},
                  ];
                  if (widget.name == "Alcohol") {
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
                                        image: NetworkImage(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/alcohol/alcohol2.jpg"),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 25,
                                      color: Colors.white,
                                    ),
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
                                        "Alcohol",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular'),
                                      ),
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
                                      /*Image.asset(
                                        "assets/images/exclamation.png",
                                        height: 40,
                                        width: 40,
                                      ),*/
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

                          columnItem("assets/images/arrow.png",
                              data[1]["title"], data[1]["content"], alcohol[0]),
                          columnItem("assets/images/arrow.png",
                              data[2]["title"], data[2]["content"], ""),

                          columnItem("assets/images/arrow.png",
                              data[3]["title"], data[3]["content"], alcohol[2]),
                          columnItem("assets/images/arrow.png",
                              data[4]["title"], data[4]["content"], alcohol[3]),
                          columnItem("assets/images/arrow.png",
                              data[5]["title"], data[5]["content"], ""),

                          /*columnItem("assets/images/arrow.png",
                              data[6]["title"], data[6]["content"], alcohol[4]),*/
                        ],
                      ),
                    );
                  }
                  if (widget.name == "Heroine") {
                    //print(data[9]);
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
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
                                        "Heroine",
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

                          columnItem(
                              "assets/images/couple.png",
                              data[8]["title"],
                              data[8]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/heroine1.jpg"),
                          columnItem("assets/images/couple.png",
                              data[9]["title"], data[9]["content"], ""),
                          columnItem(
                              "assets/images/couple.png",
                              data[10]["title"],
                              data[10]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/heroine2.jpg"),
                          columnItem(
                              "assets/images/arrow.png",
                              data[11]["title"],
                              data[11]["content"],
                              "http://rada.uonbi.ac.ke/radaweb/appimages/heroine3.jpg"),
                        ],
                      ),
                    );
                  }
                  if (widget.name == "Weed") {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
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
                                        "Weed",
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
                              data[13]["title"], data[13]["content"], weed[0]),
                          columnItem("assets/images/couple.png",
                              data[14]["title"], data[14]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[15]["title"], data[15]["content"], weed[2]),
                          columnItem("assets/images/couple.png",
                              data[16]["title"], data[16]["content"], ""),
                          columnItem("assets/images/couple.png",
                              data[17]["title"], data[17]["content"], ""),

                          columnItem("assets/images/couple.png",
                              data[18]["title"], data[18]["content"], weed[5]),
                          columnItem("assets/images/couple.png",
                              data[19]["title"], data[19]["content"], ""),
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

  Widget circularProgress() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.amber),
        );
      },
    );
  }

  Widget columnItem(
      String image, String title, String content, String mainimage) {
    return Column(
      children: <Widget>[
        mainimage == ""
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 150,
                        width: 200,
                        color: Colors.grey[200],
                        child: Image.network(
                          mainimage,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                        /*child: CachedNetworkImage(
                      imageUrl: mainimage,
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
                          )),*/
                      )),
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
                    /*Image.asset(
                      image,
                      height: 40,
                      width: 40,
                    ),*/
                    /*SizedBox(
                      width: 10,
                    ),*/
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
