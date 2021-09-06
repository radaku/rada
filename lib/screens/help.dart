import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/faq.dart';
import 'package:radauon/screens/maps.dart';
import 'package:radauon/screens/querypage.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final List<Map> imgList = [];
  final List<Map> newsList = [];
  Map news;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          bottom: TabBar(
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(
                text: "Locations",
              ),
              Tab(text: "Contacts"),
              Tab(text: "Bot"),
              Tab(text: "Services"),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Platform.isAndroid?Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 27,
            ):Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 27,
            ),
          ),
          title: NeumorphicText(
            "Help & Contacts",
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
          /*actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.more_horiz,
                  size: 27,
                  color: Colors.white,
                )),
          ],*/
          centerTitle: true,
          elevation: 0,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Location(),
            myContacts(),
            RadaDialogflow(),
            services(),
          ],
        ),
      ),
    );
  }

  List<Map> conts = [
    {
      "name": "Main Campus Counsellor",
      "email": "counselling@uonbi.ac.ke",
      "phone": "020555414235"
    },
    {
      "name": "Chiromo Counselling",
      "email": "counsellingchiromo@uonbi.ac.ke",
      "phone": "020145789"
    }
  ];

  Widget myContacts() {
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
                        "Email: ${newsList[index]["email"]}\nPhone: ${newsList[index]["phone"]}",
                        style: TextStyle(color: Colors.black.withAlpha(170)),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        "Name: " + newsList[index]["name"],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        "Email: ${newsList[index]["email"]}\nPhone: ${newsList[index]["phone"]}",
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
    getContacts();
  }

  void getContacts() async {
    print('Fetching Contacts...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/contacts/get/1',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }

    for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
      //print(imgList);
    }
    //print(newsList);
  }

  Widget services() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: OutlineButton(
              /*width: MediaQuery.of(context).size.width,
              height: 50,
              text: 'Justice Issues',
              icon: Icons.map,*/
              child: Text(
                "Justice Issues",
                style: TextStyle(color: Colors.amber[800]),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            QueryPage(id: 1, name: "Justice Issues")));
              },
              //backgroundColor: Colors.amber,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: OutlineButton(
              /*width: MediaQuery.of(context).size.width,
              height: 50,
              text: 'Academic Matters',
              icon: Icons.map,*/
              child: Text(
                "Academic Matters",
                style: TextStyle(color: Colors.green[400]),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            QueryPage(id: 2, name: "Academic Matters")));
              },
              //backgroundColor: Colors.indigo,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: OutlineButton(
              child: Text("University Accomodation",
                  style: TextStyle(color: Colors.blue)),
              /*width: MediaQuery.of(context).size.width,
              height: 50,
              text: 'University Accomodation',
              icon: Icons.format_align_justify,*/
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            QueryPage(id: 3, name: "University Accomodation")));
              },
              //backgroundColor: Colors.purple,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: OutlineButton(
              /* width: MediaQuery.of(context).size.width,
              height: 50,
              text: 'App issues',
              icon: Icons.format_align_justify,*/
              child: Text("App perfomance issues",
                  style: TextStyle(color: Colors.deepOrangeAccent)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            QueryPage(id: 4, name: "App issues")));
              },
              //backgroundColor: Colors.redAccent,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: OutlineButton(
              /*width: MediaQuery.of(context).size.width,
              height: 50,
              text: 'Other issues',
              icon: Icons.format_align_justify,*/
              child:
                  Text("Other issues", style: TextStyle(color: Colors.brown)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => QueryPage(
                              id: 5,
                              name: "Other issues",
                            )));
              },
              //backgroundColor: Colors.indigoAccent,
            ),
          ),
        ),
      ],
    );
  }
}
