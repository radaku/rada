import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllIssues extends StatefulWidget {
  @override
  _AllIssuesState createState() => _AllIssuesState();
}

class _AllIssuesState extends State<AllIssues> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Map> imgList = [];
  final List<Map> newsList = [];
  Map issue;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid = [];

  void getIssues(String id) async {
    print('Fetching Issues...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/help/get/${id}',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      issue = convert[i];
      setState(() {
        newsList.add(issue);
      });
    }

    for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
    }
    //print(newsList);
  }

  Widget issuesList() {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: newsList.length,
        itemBuilder: (_, int index) {
          return newsList.length == 0
              ? Center(
                  child: Text("Fetching pending submisions"),
                )
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    index % 2 == 0
                        ? ListTile(
                            title: Text(
                              "Issue Id: " + newsList[index]["id"].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              "Status: unresolved\nDate: ${newsList[index]["created_at"]}",
                              style:
                                  TextStyle(color: Colors.green.withAlpha(170)),
                            ),
                            trailing: Icon(
                              Icons.notifications,
                              color: Colors.grey[300],
                            ),
                          )
                        : ListTile(
                            title: Text(
                              "Issue Id: " + newsList[index]["id"].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              "Status: unresolved\nDate: ${newsList[index]["created_at"]}",
                              style:
                                  TextStyle(color: Colors.green.withAlpha(170)),
                            ),
                            trailing: Icon(
                              Icons.notifications,
                              color: Colors.grey[300],
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
    setState(() {
      getId();
    });
  }

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      getIssues(user.uid);
      setState(() {
        useruid.add(user.uid);
      });
    });

    print(useruid[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[100],
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 27,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pending Issues",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ):AppBar(
        backgroundColor: Colors.grey[100],
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 27,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pending Issues",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ),
      body: issuesList(),
    );
  }
}
