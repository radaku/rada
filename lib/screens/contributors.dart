import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;

class Contributors extends StatefulWidget {
  @override
  _ContributorsState createState() => _ContributorsState();
}

class _ContributorsState extends State<Contributors> {
  final List<Map> imgList = [];
  final List<Map> newsList = [];
  Map news;

  void getContriboturs() async {
    print('Fetching Contacts...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/contributors',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }

    for (var i = 0; i < newsList.length; i++) {
      setState(() {
        imgList.add(newsList[i]);
      });
      //print(imgList);
    }
    //print(newsList);
  }

  Widget contributors() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: newsList.length,
        itemBuilder: (_, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              index % 2 == 0
                  ? ListTile(
                      title: Text(
                        "Name: " + newsList[index]["name"],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        "University: ${newsList[index]["university"]}\nRole: ${newsList[index]["role"]}",
                        style: TextStyle(color: Colors.black.withAlpha(170)),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        "Name: " + newsList[index]["name"],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        "University: ${newsList[index]["university"]}\nRole: ${newsList[index]["role"]}",
                        style: TextStyle(color: Colors.black.withAlpha(170)),
                      ),
                    ),
              Divider()
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContriboturs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: false,
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
        title: NeumorphicText(
          "Contributors",
          style: NeumorphicStyle(
            depth: 0, //customize depth here
            color: Colors.black,
            shape: NeumorphicShape.convex, //customize color here
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 20, //customize size here
          ),
        ),
      ):AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: false,
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
        title: NeumorphicText(
          "Contributors",
          style: NeumorphicStyle(
            depth: 0, //customize depth here
            color: Colors.black,
            shape: NeumorphicShape.convex, //customize color here
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 20, //customize size here
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
              padding: EdgeInsets.only(left: 10), child: Text("Facilitators")),*/
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRHdbXsZFegT3z4vk4D1Tmo79k0CCYovR4Cgw&usqp=CAU",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                      "https://pbs.twimg.com/profile_images/844908360822607872/MFsvCY4p.jpg",
                      fit: BoxFit.contain),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/en/a/a0/Uon_emblem.gif",
                      fit: BoxFit.contain),
                )
              ],
            ),
          ),
          Expanded(child: contributors())
        ],
      ),
      /*body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 170,
                    height: 180,
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRHdbXsZFegT3z4vk4D1Tmo79k0CCYovR4Cgw&usqp=CAU",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 180,
                    child: Image.network(
                        "https://pbs.twimg.com/profile_images/844908360822607872/MFsvCY4p.jpg",
                        fit: BoxFit.contain),
                  ),
                  Container(
                    width: 170,
                    height: 180,
                    child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/en/a/a0/Uon_emblem.gif",
                        fit: BoxFit.contain),
                  )
                ],
              ),
            ),
            contributors(),
          ],
        )*/
    );
  }
}
