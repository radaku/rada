import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/mentors.dart';

class MentorshipRequest extends StatefulWidget {
  @override
  _MentorshipRequestState createState() => _MentorshipRequestState();
}

class _MentorshipRequestState extends State<MentorshipRequest> {
  final regController = TextEditingController();
  final collegeController = TextEditingController();
  final schoolController = TextEditingController();
  final expectController = TextEditingController();
  final goalsController = TextEditingController();
  final _studyController = TextEditingController();

  bool sending = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List useruid = [];

  double _height = 0;
  String _message = "";

  String _color = '';

  var _dropDownValue;
  var _dropDownValue1;

  final List<Map> newsList = [];
  final List<Map> newsList1 = [];
  Map news;
  Map news1;

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      useruid.add(user.uid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFaculties();

    getTypes();

    setState(() {
      getId();
    });
  }

  void getFaculties() async {
    //newsList.clear();
    //newsList1.clear();
    print('Fetching Faculties...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/faculties/get/1',
        headers: {"Accept": "application/json"});

    print(response.body);

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }

    /*for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
      //print(imgList);
    }
    fetched = true;*/
    //print(newsList);
  }

  void getTypes() async {
    //newsList1.clear();
    //newsList1.clear();
    print('Fetching Faculties...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/mentor/type',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news1 = convert[i];
      setState(() {
        newsList1.add(news1);
      });
    }

    /*for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
      //print(imgList);
    }
    fetched = true;*/
    //print(newsList);
  }

  @override
  Widget build(BuildContext context) {
    /*getFaculties();
    getTypes();*/
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Mentorship Request",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
          "Mentorship Request",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: _height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  _message,
                  style: TextStyle(
                      color: _message == "Something Went Wrong"
                          ? Colors.red
                          : Colors.green),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: TextField(
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  controller: regController,
                  cursorColor: Colors.black,
                  cursorWidth: 3.0,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Registration Number',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    contentPadding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.grey[200]),
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: TextField(
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  controller: _studyController,
                  cursorColor: Colors.black,
                  cursorWidth: 3.0,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Year Of Study',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    contentPadding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.grey[200]),
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                height: 60,
                child: Neumorphic(
                  margin: EdgeInsets.only(top: 7),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(0)),
                      depth: 0,
                      lightSource: LightSource.topLeft,
                      color: Colors.grey[100]),
                  child: FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color: Colors.grey[200]),
                              borderSide: BorderSide(color: Colors.grey[100]),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[100]),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 5, left: 10, bottom: 5)),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: DropdownButton(
                            focusColor: Colors.grey[100],
                            hint: _dropDownValue1 == null
                                ? Text(
                                    'Select Mentor Type',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Raleway-regular',
                                        fontSize: 15),
                                  )
                                : Text(
                                    _dropDownValue1,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Raleway-regular',
                                        fontSize: 18),
                                  ),
                            isExpanded: true,
                            iconSize: 30.0,
                            style: TextStyle(color: Colors.grey[600]),
                            items: newsList1.map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: newsList1.length > 0
                                      ? val["id"].toString()
                                      : 0,
                                  child: Text(val["type"]),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              newsList1.forEach((element) {
                                if (element["id"].toString() == val &&
                                    newsList1.length > 0) {
                                  setState(() {
                                    _dropDownValue1 = element["type"];
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        focusColor: Colors.grey[100],
                        hint: _dropDownValue == null
                            ? Text(
                                'Select Faculty',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Raleway-regular',
                                    fontSize: 15),
                              )
                            : Text(
                                _dropDownValue,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Raleway-regular',
                                    fontSize: 18),
                              ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.grey[600]),
                        items: newsList.map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val["name"].toString(),
                              child: Text(val["name"]),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          //getCampuses(int.parse(val));
                          newsList.forEach((element) {
                            if (element["id"].toString() == val) {
                              setState(() {
                                _dropDownValue = element["name"];
                              });
                            }
                          });
                          setState(() {
                            _dropDownValue = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),

                  controller: expectController,
                  cursorColor: Colors.black,
                  cursorWidth: 3.0,
                  //keyboardType: TextInputType.emailAddress,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'What are your expectations?',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.only(
                        top: 18, bottom: 18, left: 15, right: 15),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.grey[200]),
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),

                  controller: goalsController,
                  cursorColor: Colors.black,
                  cursorWidth: 3.0,
                  //keyboardType: TextInputType.emailAddress,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Please State Your Goals',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.only(
                        top: 18, bottom: 18, left: 15, right: 15),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.grey[200]),
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[100]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            sending
                ? circularProgress()
                : Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 49,
                      child: RaisedButton(
                        onPressed: () {
                          sendRequest();
                        },
                        color: Colors.blue,
                        elevation: 0,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void sendRequest() async {
    setState(() {
      sending = true;
    });

    http.Response response = await http
        .post('http://rada.uonbi.ac.ke/radaweb/api/requests/store', headers: {
      "Accept": "application/json"
    }, body: {
      "type": _dropDownValue1,
      "expectations": expectController.text,
      "student_regNo": regController.text,
      "school": _dropDownValue,
      "goals": goalsController.text,
      "acceptance": "true",
      "year_of_study": _studyController.text,
      "user_id": useruid[0]
    });

    print(response.statusCode);

    if (response.statusCode == 500) {
      setState(() {
        _message = "Something Went Wrong";
        _height = 60;
      });
      Future.delayed(const Duration(milliseconds: 10000), () {
        setState(() {
          _height = 0;
        });
      });
    } else if (response.statusCode == 200) {
      setState(() {
        _message = "Success, request sent";
        _height = 60;
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _height = 0;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => Mentors(
                      id: useruid[0],
                      type: "user",
                    )));
      });
    }

    print(response.body);
    setState(() {
      sending = false;
    });
  }

  Widget circularProgress() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.blueAccent),
        );
      },
    );

    //SpinKitThreeBounce
  }
}
