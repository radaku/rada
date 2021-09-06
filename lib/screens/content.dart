import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/model/reproductive.dart';
import 'package:radauon/utils/reproductive_helper.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentPage extends StatefulWidget {
  int id;
  String name;
  String image;
  String itemkey;

  ContentPage({Key key, @required this.id, this.name, this.image, this.itemkey})
      : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  Map data;
  List data_list = [];

  ReproHelper reproHelper;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  YoutubePlayerController _controller2;
  YoutubePlayerController _controller3;
  YoutubePlayerController _controller4;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  TextEditingController _idController;
  TextEditingController _seekToController;

  static String cont =
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose injected humour and the like";

  var width, height;
  var items = [
    {"image": "assets/images/drugs.jpg", "name": "Marijuana", "Content": cont},
    {"image": "assets/images/heroine.jpg", "name": "Heroine", "Content": cont},
    {"image": "assets/images/alcohol.jpg", "name": "Alcohol", "Content": cont},
    {"image": "assets/images/other.jpg", "name": "Other Drugs", "Content": cont}
  ];

  List<String> srh = [
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception1.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception2.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception3.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception4.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception5.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception6.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception7.jpg",
    "http://rada.uonbi.ac.ke/radaweb/appimages/contraception/SRH%20contraception8.jpg"
  ];

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  List<String> videos = [
    "https://www.youtube.com/watch?v=V2Aj-iJ6p38",
    "https://www.youtube.com/watch?v=NCJH2qpxVy0",
    "https://www.youtube.com/watch?v=n0QwdKI3xws",
    "https://www.youtube.com/watch?v=7Sbgg8icODY"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reproHelper = ReproHelper();

    _controller = YoutubePlayerController(
      //initialVideoId: _ids.first,
      initialVideoId: YoutubePlayer.convertUrlToId(videos[0]),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _controller2 = YoutubePlayerController(
      //initialVideoId: _ids.first,
      initialVideoId: YoutubePlayer.convertUrlToId(videos[1]),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _controller3 = YoutubePlayerController(
      //initialVideoId: _ids.first,
      initialVideoId: YoutubePlayer.convertUrlToId(videos[2]),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

    _controller4 = YoutubePlayerController(
      //initialVideoId: _ids.first,
      initialVideoId: YoutubePlayer.convertUrlToId(videos[3]),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    @override
    void deactivate() {
      // Pauses video while navigating to next page.
      _controller.pause();
      super.deactivate();
    }

    @override
    void dispose() {
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
      super.dispose();
    }

    getContent();
  }

  Future<String> getContent() async {
    print("Stating..............");
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/categories/get/${widget.itemkey}',
        headers: {"Accept": "application/json"});
    var converted = json.decode(response.body);
    for (var i = 0; i < converted.length; i++) {
      data = converted[i];
      setState(() {
        data_list.add(data);
      });
    }

    /*for(var i=0;i<data_list[0]["category_sub_cat"].length;i++){
       print(data_list[0]["category_sub_cat"][i]);
     }*/

    return "nothing";
  }

  Future getProjectDetails() async {
    List<Reproductive> messages = await reproHelper.getMessages();
    return messages;
  }

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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar:Platform.isIOS?AppBar(
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
      ):SizedBox(height: 0,width: 0,),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              return ListView.builder(
                itemCount: projectSnap.data == null ? 0 : 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Reproductive project = projectSnap.data[0];
                  Reproductive project2 = projectSnap.data[2];
                  Reproductive project3 = projectSnap.data[1];
                  Reproductive project4 = projectSnap.data[3];

                  /*reproHelper.delete().then((value){
                    print("Everything has been deleted");
                  });*/

                  //reproHelper.delete(index);

                  if (widget.itemkey == "3") {
                    var data = [
                      {"title": "Did you know", "content": project.dyn1},
                      {
                        "title": "Boyfriend and Girlfriend",
                        "content": project.boyfriend
                      },
                      {"title": "One Night Stand", "content": project.night},
                      {
                        "title": "Casual Sexual Relationships",
                        "content": project.casual
                      },
                      {
                        "title": "Sponsors and Ben10",
                        "content": project.sponsor
                      },
                      {
                        "title": "Sponsor Video Series",
                        "content": project.sponsorvideo
                      },

                      //from 6
                      {
                        "title": "Did you know",
                        "content": project2.pregnancydyn
                      },
                      {
                        "title": "Causes of Campus Pregnancy",
                        "content": project2.pregnancycauses
                      },
                      {
                        "title": "Pregnancy Signs",
                        "content": project2.pregnancysigns
                      },
                      {
                        "title": "Pregnancy Test",
                        "content": project2.pregnancytest
                      },
                      {
                        "title": "Prenatal Care",
                        "content": project2.pregnancytest
                      },
                      {
                        "title": "Antenatal Care",
                        "content": project2.antinetalcare
                      },
                      {
                        "title": "Postnatal Care",
                        "content": project2.postnatal
                      },
                      {
                        "title": "Pregnant and Mothers Nutrition",
                        "content": project2.pregnancynutrition
                      },
                      {
                        "title": "Danger Signs in Pregnancy",
                        "content": project2.pregnancydanger
                      },

                      //from 15
                      {
                        "title": "Introduction",
                        "content": project3.contraceptionintroduction
                      },
                      {"title": "Methods", "content": project3.methods},
                      {
                        "title": "How Condoms Work",
                        "content": project3.condomswork
                      },
                      {
                        "title": "Injectable Contraceptive",
                        "content": project3.injectable
                      },
                      {
                        "title": "Combined Oral Pill",
                        "content": project3.oralpill
                      },
                      {
                        "title": "Intra Uterine Contraceptive Devices(IUCDs)",
                        "content": project3.iucds
                      },
                      {"title": "Implants", "content": project3.implants},
                      {
                        "title": "Emergency Contraceptive Pill",
                        "content": project3.emergency
                      },
                      {
                        "title": "Contraceptive Video",
                        "content": project3.contraceptionvideo
                      },

                      //from 24
                      {
                        "title": "Introduction",
                        "content": project4.stiintroduction
                      },
                      {
                        "title": "Risk Factors",
                        "content": project4.riskfactors
                      },
                      {"title": "STI Types", "content": project4.stitypes},
                      {
                        "title": "Signs of an STI",
                        "content": project4.stisigns
                      },
                      {
                        "title": "Common STIs Symptoms",
                        "content": project4.commonstisigns
                      },
                      {"title": "Treatment", "content": project4.treatment},
                      {
                        "title": "Protection Tips",
                        "content": project4.protectiontips
                      },
                      {"title": "Facts", "content": project4.facts},
                      {"title": "Myths", "content": project4.myths},
                      {
                        "title": "Bodily Harm of STIs",
                        "content": project4.stisharm
                      },
                      {"title": "HIV and STIs", "content": project4.hivsti},
                    ];

                    if (widget.name == "Relationships") {
                      if (!projectSnap.hasData) {
                        return Center(
                          child: Text("Fetching Content"),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            /*Stack(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.colorBurn,
                                                ),
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          Center(child: circularProgress()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                            child: Icon(
                                              Icons.error,
                                              size: 40,
                                            ),
                                          )),

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
                                          "Campus Sexual Relationships",
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
                              margin:
                                  EdgeInsets.only(top: 5, right: 5, left: 5),
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
                                              fontFamily: 'Raleway-regular',
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: Text(
                                        data[index]["content"].toString(),
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
                            //Images part
                            //youtube video
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.redAccent,
                                  child: YoutubePlayerBuilder(
                                      onExitFullScreen: () {
                                        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                        SystemChrome.setPreferredOrientations(
                                            DeviceOrientation.values);
                                      },
                                      player: YoutubePlayer(
                                        controller: _controller,
                                        showVideoProgressIndicator: true,
                                        progressIndicatorColor:
                                            Colors.blueAccent,
                                        topActions: <Widget>[
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Text(
                                              _controller.metadata.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.settings,
                                              color: Colors.white,
                                              size: 25.0,
                                            ),
                                            onPressed: () {
                                              print('Settings Tapped!');
                                            },
                                          ),
                                        ],
                                        onReady: () {
                                          _isPlayerReady = true;
                                        },
                                        onEnded: (data) {
                                          print("Ended");
                                        },
                                      ),
                                      builder: (context, player) => Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: player,
                                          )),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          height: 150,
                                          width: 250,
                                          color: Colors.white,
                                          child: Image.network(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/dating1.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          height: 150,
                                          width: 250,
                                          color: Colors.white,
                                          child: Image.network(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/dating2.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          height: 250,
                                          width: 200,
                                          color: Colors.white,
                                          child: Image.network(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/dating3.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ))),
                                ],
                              ),
                            ),
                            Neumorphic(
                              margin:
                                  EdgeInsets.only(top: 10, right: 5, left: 5),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(0)),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Boyfriend and Girlfriend".toString(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Raleway-regular'),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: ReadMoreText(
                                        data[1]["content"].toString(),
                                        trimLines: 7,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...read more',
                                        trimExpandedText: ' show less',
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

                            //scond images
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          height: 150,
                                          width: 250,
                                          color: Colors.white,
                                          child: Image.network(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/dating5.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                          height: 150,
                                          width: 270,
                                          color: Colors.white,
                                          child: Image.network(
                                            "http://rada.uonbi.ac.ke/radaweb/appimages/dating6.jpg",
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ))),
                                ],
                              ),
                            ),

                            Neumorphic(
                              margin:
                                  EdgeInsets.only(top: 10, right: 5, left: 5),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(0)),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          data[2]["title"].toString(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Raleway-regular',
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: ReadMoreText(
                                        data[2]["content"].toString(),
                                        trimLines: 3,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...read more',
                                        trimExpandedText: ' show less',
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

                            //Third images
                            columnItem(
                                "http://rada.uonbi.ac.ke/radaweb/appimages/dating4.jpg",
                                data[3]["title"],
                                data[3]["content"]),
                            columnItem(
                                "null", data[4]["title"], data[4]["content"]),
                            /*columnItem(
                                "null", data[5]["title"], data[5]["content"]),*/
                          ],
                        ),
                      );
                    } else if (widget.name == "Pregnancy") {
                      //Pregnancy content start
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            /*Stack(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.colorBurn,
                                                ),
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          Center(child: circularProgress()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                            child: Icon(
                                              Icons.error,
                                              size: 40,
                                            ),
                                          )),
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
                                          "Campus Pregnancy",
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
                              margin:
                                  EdgeInsets.only(top: 5, right: 5, left: 5),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(2)),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          data[6]["title"].toString(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Raleway-regular'),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: Text(
                                        data[6]["content"].toString(),
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular',
                                            letterSpacing: 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.redAccent,
                                          child: YoutubePlayerBuilder(
                                              onExitFullScreen: () {
                                                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                                SystemChrome
                                                    .setPreferredOrientations(
                                                        DeviceOrientation
                                                            .values);
                                              },
                                              player: YoutubePlayer(
                                                controller: _controller2,
                                                showVideoProgressIndicator:
                                                    true,
                                                progressIndicatorColor:
                                                    Colors.blueAccent,
                                                topActions: <Widget>[
                                                  const SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                      _controller2
                                                          .metadata.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.settings,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    onPressed: () {
                                                      print('Settings Tapped!');
                                                    },
                                                  ),
                                                ],
                                                onReady: () {
                                                  _isPlayerReady = true;
                                                },
                                                onEnded: (data) {
                                                  print("Ended");
                                                },
                                              ),
                                              builder: (context, player) =>
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: player,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Images part

                            //Four images
                            /*pregnancyItem(
                                "assets/images/exclamation.png",
                                data[6]["title"],
                                data[6]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy1.jpg"),*/
                            pregnancyItem(
                                "assets/images/arrow.png",
                                data[7]["title"],
                                data[7]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy2.jpg"),
                            pregnancyItem(
                                "assets/images/arrow.png",
                                data[8]["title"],
                                data[8]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy4.jpg"),
                            pregnancyItem(
                                "assets/images/arrow.png",
                                data[9]["title"],
                                data[9]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy3.jpg"),
                            pregnancyItem(
                                "assets/images/arrow.png",
                                data[10]["title"],
                                data[10]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy5.jpg"),
                            pregnancyItem(
                                "assets/images/arrow.png",
                                data[11]["title"],
                                data[11]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy6.jpg"),
                            pregnancyItem("assets/images/arrow.png",
                                data[12]["title"], data[12]["content"], "null"),
                            pregnancyItem("assets/images/arrow.png",
                                data[13]["title"], data[13]["content"], "null"),
                            pregnancyItem("assets/images/arrow.png",
                                data[14]["title"], data[14]["content"], "null")
                          ],
                        ),
                      );
                      //Pregnancy content end

                    } else if (widget.name == "Contraception") {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Neumorphic(
                              margin:
                                  EdgeInsets.only(top: 5, right: 5, left: 5),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(2)),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          data[15]["title"].toString(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Raleway-regular'),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: Text(
                                        data[15]["content"].toString(),
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular',
                                            letterSpacing: 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.redAccent,
                                          child: YoutubePlayerBuilder(
                                              onExitFullScreen: () {
                                                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                                SystemChrome
                                                    .setPreferredOrientations(
                                                        DeviceOrientation
                                                            .values);
                                              },
                                              player: YoutubePlayer(
                                                controller: _controller3,
                                                showVideoProgressIndicator:
                                                    true,
                                                progressIndicatorColor:
                                                    Colors.blueAccent,
                                                topActions: <Widget>[
                                                  const SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                      _controller3
                                                          .metadata.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.settings,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    onPressed: () {
                                                      print('Settings Tapped!');
                                                    },
                                                  ),
                                                ],
                                                onReady: () {
                                                  _isPlayerReady = true;
                                                },
                                                onEnded: (data) {
                                                  print("Ended");
                                                },
                                              ),
                                              builder: (context, player) =>
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: player,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*contraceptionItem(
                                "assets/images/arrow.png",
                                data[14]["title"],
                                data[14]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception1.jpg"),
                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[14]["title"],
                                data[14]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy1.jpg"),
                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[18]["title"],
                                data[18]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception8.jpg"),*/

                            /*contraceptionItem(
                                "assets/images/arrow.png",
                                data[15]["title"],
                                data[15]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception1.jpg"),*/

                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[16]["title"],
                                data[16]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception1.jpg"),
                            /*contraceptionItem(
                                "assets/images/arrow.png",
                                data[17]["title"],
                                data[17]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/pregnancy1.jpg"),*/
                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[18]["title"],
                                data[18]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception8.jpg"),
                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[19]["title"],
                                data[19]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception9.jpg"),
                            contraceptionItem(
                                "assets/images/arrow.png",
                                data[20]["title"],
                                data[20]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/contraception10.jpg"),
                            contraceptionItem("assets/images/arrow.png",
                                data[21]["title"], data[21]["content"], "null"),
                            contraceptionItem("assets/images/arrow.png",
                                data[22]["title"], data[22]["content"], "null"),
                            /*contraceptionItem("assets/images/arrow.png",
                                data[23]["title"], data[23]["content"], "null"),*/
                          ],
                        ),
                      );
                    } else if (widget.name == "STIs") {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            /*Stack(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.colorBurn,
                                                ),
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          Center(child: circularProgress()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                            child: Icon(
                                              Icons.error,
                                              size: 40,
                                            ),
                                          )),
                                  */ /*decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                      image: DecorationImage(
                                          image: ExactAssetImage(
                                              "assets/images/bacteria.png"),
                                          fit: BoxFit.cover)),*/ /*
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
                                          "STIs",
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
                              margin:
                                  EdgeInsets.only(top: 5, right: 5, left: 5),
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(2)),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(5),
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
                                            fontFamily: 'Raleway-regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, top: 10),
                                      child: Text(
                                        data[24]["content"].toString(),
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Raleway-regular',
                                            letterSpacing: 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.redAccent,
                                          child: YoutubePlayerBuilder(
                                              onExitFullScreen: () {
                                                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                                SystemChrome
                                                    .setPreferredOrientations(
                                                        DeviceOrientation
                                                            .values);
                                              },
                                              player: YoutubePlayer(
                                                controller: _controller4,
                                                showVideoProgressIndicator:
                                                    true,
                                                progressIndicatorColor:
                                                    Colors.blueAccent,
                                                topActions: <Widget>[
                                                  const SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                      _controller4
                                                          .metadata.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.settings,
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    onPressed: () {
                                                      print('Settings Tapped!');
                                                    },
                                                  ),
                                                ],
                                                onReady: () {
                                                  _isPlayerReady = true;
                                                },
                                                onEnded: (data) {
                                                  print("Ended");
                                                },
                                              ),
                                              builder: (context, player) =>
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: player,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*contraceptionItem(
                                "assets/images/arrow.png",
                                data[23]["title"],
                                data[23]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti1.jpg"),*/
                            contraceptionItem(
                                "assets/images/flower.png",
                                data[26]["title"],
                                data[26]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti2.jpg"),
                            contraceptionItem(
                                "assets/images/couple.png",
                                data[27]["title"],
                                data[27]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti3.jpg"),
                            contraceptionItem(
                                "assets/images/time.png",
                                data[28]["title"],
                                data[28]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti4.jpg"),
                            contraceptionItem(
                                "assets/images/money.png",
                                data[29]["title"],
                                data[29]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti5.jpg"),
                            contraceptionItem(
                                "assets/images/video.png",
                                data[30]["title"],
                                data[30]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti9.jpg"),
                            contraceptionItem(
                                "assets/images/video.png",
                                data[31]["title"],
                                data[31]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti10.jpg"),
                            contraceptionItem(
                                "assets/images/video.png",
                                data[32]["title"],
                                data[32]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti11.jpg"),
                            contraceptionItem("assets/images/video.png",
                                data[33]["title"], data[33]["content"], "null"),
                            contraceptionItem(
                                "assets/images/video.png",
                                data[34]["title"],
                                data[34]["content"],
                                "http://rada.uonbi.ac.ke/radaweb/appimages/sti14.jpg"),
                          ],
                        ),
                      );
                    }
                  } else if (widget.itemkey == "4") {
                    return Center(
                      child: Text("For Hiv Content"),
                    );
                  } else if (widget.itemkey == "5") {
                    return Center(
                      child: Text("For Hiv Content"),
                    );
                  } else if (widget.itemkey == "6") {
                    return Center(
                      child: Text("For Hiv Content"),
                    );
                  }

                  //reproHelper.delete(index);

                  return SizedBox(
                    height: 0,
                    width: 0,
                  );
                },
              );
            } else {
              return Center(
                child: Text("Please Wait...."),
              );
            }
            return SizedBox();
          },
          future: getProjectDetails(),
        ),
      ),
    );
  }

  Widget _itemBuilder(String image, String title, String content) {
    return Container(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: Colors.white),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height * .25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    image: DecorationImage(
                        image: ExactAssetImage(image), fit: BoxFit.cover)),
              ),
              Container(
                height: height * .55,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 150,
                            child: Text(
                              title.toString(),
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontFamily: 'Raleway-regular'),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(height: 0),
                              Image.asset(
                                "assets/images/idea.png",
                                height: 30,
                                width: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Introduction",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway-regular',
                                color: Colors.blue)),
                      ),
                      Divider(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 0),
                          /*child: content.length <= 288?Text(content,*/
                          child: content.length <= 225
                              ? Text(content.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Raleway-regular',
                                      fontSize: 16))
                              : Text(
                                  content.toString().substring(0, 225) +
                                      " ....",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Raleway-regular',
                                      fontSize: 16)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 11),
                          child: FlatButton(
                              child: Text(
                                "Read more",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.pink,
                              onPressed: () {}),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget columnItem(
    String image,
    String title,
    String content,
  ) {
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
                    colorClickableText: Colors.pink,
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

  Widget contraceptionItem(
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
                          title
                              .toString() /*== "Contraceptive Video"
                              ? "Emergency Contraceptive Pill...cont"
                              : title.toString*/
                          ,
                          //title.toString(),
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
                    colorClickableText: Colors.pink,
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

  Widget pregnancyItem(
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
                    colorClickableText: Colors.pink,
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

  Widget stiItem(String icon, String title, String content, String image) {
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
                  padding: EdgeInsets.only(left: 0, top: 10),
                  child: ReadMoreText(
                    content.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.pink,
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
}
