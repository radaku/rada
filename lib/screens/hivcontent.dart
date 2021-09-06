import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:radauon/model/hivmodel.dart';
import 'package:radauon/utils/hiv_helper.dart';
import 'package:readmore/readmore.dart';

class HivContent extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  HivContent({Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _HivContentState createState() => _HivContentState();
}

class _HivContentState extends State<HivContent> {
  Map data;
  List data_list = [];

  HivHelper hivHelper;

  var width, height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hivHelper = HivHelper();
  }

  Future getProjectDetails() async {
    List<HivModel> messages = await hivHelper.getMessages();
    return messages;
  }

  Widget hivItem(String icon, String title, String content, String image) {
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
                HivModel project = projectSnap.data[index];
                //hivHelper.delete(index);
                var data = [
                  {"title": "Definition", "content": project.definition},
                  {
                    "title": "Kenya and HIV and AIDS",
                    "content": project.kenyahiv
                  },
                  {"title": "HIV Symptoms", "content": project.hivsymptoms},
                  {
                    "title": "Transmission Modes",
                    "content": project.transmissionmodes
                  },
                  {
                    "title": "Not Transmitted Through",
                    "content": project.nottransmitted
                  },
                  {
                    "title": "Myths on HIV and AIDS",
                    "content": project.hivmyths
                  },
                  {"title": "Prevention", "content": project.hivprevention},
                  {
                    "title": "Mother to Child Transamission",
                    "content": project.mothertochild
                  },
                  {
                    "title": "HIV and AIDS Stigma",
                    "content": project.hivstigma
                  },
                ];
                //Singl scroll start
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
                                    "Hiv & Aids",
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

                      //Third images
                      //columnItem("assets/images/couple.png", data[0]["title"], data[0]["content"]),
                      hivItem(
                          "assets/images/arrow.png",
                          data[1]["title"],
                          data[1]["content"],
                          "http://rada.uonbi.ac.ke/radaweb/appimages/hiv1.jpg"),
                      hivItem(
                          "assets/images/arrow.png",
                          data[2]["title"],
                          data[2]["content"],
                          "http://rada.uonbi.ac.ke/radaweb/appimages/hiv2.jpg"),

                      hivItem("assets/images/arrow.png", data[3]["title"],
                          data[3]["content"], "null"),
                      hivItem("assets/images/arrow.png", data[4]["title"],
                          data[4]["content"], "null"),
                      hivItem("assets/images/couple.png", data[5]["title"],
                          data[5]["content"], "null"),

                      hivItem(
                          "assets/images/couple.png",
                          data[6]["title"],
                          data[6]["content"],
                          "http://rada.uonbi.ac.ke/radaweb/appimages/hiv5.jpg"),
                      hivItem("assets/images/couple.png", data[7]["title"],
                          data[7]["content"], "null"),
                      hivItem("assets/images/couple.png", data[8]["title"],
                          data[8]["content"], "null"),
                    ],
                  ),
                );
                //Single scroll end
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
