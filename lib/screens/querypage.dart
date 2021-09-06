import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/allissues.dart';
import 'package:radauon/screens/help.dart';

class QueryPage extends StatefulWidget {
  int id;
  String name;

  QueryPage({Key key, @required this.id, this.name}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  bool sending = false;

  int _switch = 1;

  final regController = TextEditingController();
  final collegeController = TextEditingController();
  final schoolController = TextEditingController();
  final categoryController = TextEditingController();
  final nameController = TextEditingController();

  final phoneController = TextEditingController();
  final natureController = TextEditingController();
  final issueController = TextEditingController();

  bool sent = false;

  double _height = 0;

  int _switcher = 1;

  var _dropDownValue2;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid = [];

  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];

  String _color = '';

  var _dropDownValue;
  var _dropDownValue1;

  final List<Map> newsList = [];
  Map news;
  final List<Map> newsList1 = [];
  Map news1;

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        useruid.add(user.uid);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaculties();
    setState(() {
      getId();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getId();
    });
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
          widget.name,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => AllIssues()));
                },
                child: Icon(
                  Icons.filter_list,
                  size: 27,
                  color: Colors.black,
                ),
              )),
        ],
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
          widget.name,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => AllIssues()));
                },
                child: Icon(
                  Icons.filter_list,
                  size: 27,
                  color: Colors.black,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: widget.id == 1
            ? justiceForm()
            : widget.id == 2
                ? academicForm()
                : widget.id == 3
                    ? academicForm()
                    : widget.id == 4
                        ? appForm()
                        : othersForm(),
      ),
    );
  }

  void getFaculties() async {
    newsList.clear();
    //newsList1.clear();
    print('Fetching Faculties...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/faculties/get/1',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }

    print(newsList);

    /*for (var i = 0; i < newsList.length; i++) {
      imgList.add(newsList[i]);
      //print(imgList);
    }
    fetched = true;*/
    //print(newsList);
  }

  void sendRequest(BuildContext context) async {
    setState(() {
      sending = true;
    });
    /*http.Response response = await http*/
    var response = await http
        .post('http://rada.uonbi.ac.ke/radaweb/api/help/store', headers: {
      "Accept": "application/json"
    }, body: {
      "regno": regController.text,
      //"college": collegeController.text,
      "school": _dropDownValue,
      "category": categoryController.text,
      "name": nameController.text,
      "phone": phoneController.text,
      "natureofcomplaint": natureController.text,
      "category_id": "1",
      "issue": issueController.text,
      "userid": useruid[0]
    });

    print(response.statusCode);

    if (response.statusCode == 500) {
      setState(() {
        _height = 60;
      });
      Future.delayed(const Duration(milliseconds: 10000), () {
        setState(() {
          _height = 0;
        });
      });
    } else if (response.statusCode == 200) {
      setState(() {
        _height = 60;
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => Help()));
        setState(() {
          _height = 0;
        });
      });
    }

    print(response.statusCode);

    /* Navigator.push(context, MaterialPageRoute(builder: (ctx) => Help()));*/

    if (response.body.toString() == "success") {
      setState(() {
        sent = true;
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

  Widget justiceForm() {
    return Column(
      children: <Widget>[
        Container(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "Success. Response in 4 to 6 days",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Neumorphic(
            margin: EdgeInsets.only(top: 7, left: 10, right: 10),
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(0)),
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
                          EdgeInsets.only(top: 0, left: 10, bottom: 0)),
                  isEmpty: _color == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: _dropDownValue2 == null
                          ? Text('Anonimity',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway-regular',
                                  fontSize: 15))
                          : Text(
                              _dropDownValue2,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway-regular',
                                  fontSize: 15),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.grey[600]),
                      items: ['Anonymous', 'Open'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          _dropDownValue2 = val;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        /*Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remain Anonymous",
                style: TextStyle(fontSize: 20),
              ),
              ToggleSwitch(
                minWidth: 70.0,
                cornerRadius: 10.0,
                activeBgColor: Colors.cyan,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: 1,
                labels: ['YES', 'NO'],
                icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
                onToggle: (index) {
                  _switch = index;
                  print('switched to: $index');
                },
              ),
            ],
          ),
        ),*/
        _dropDownValue2 == 'Anonymous'
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    controller: regController,
                    cursorColor: Colors.grey[600],
                    cursorWidth: 3.0,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Registration Number',
                      hintStyle: TextStyle(color: Colors.grey[500]),
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
        _dropDownValue2 == 'Anonymous'
            ? SizedBox()
            : Padding(
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
                                value: val["id"].toString(),
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
                            /*setState(() {
                                                  _dropDownValue = val;
                                                });*/
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.grey[600], fontSize: 18),

            controller: issueController,
            cursorColor: Colors.white,
            cursorWidth: 3.0,
            //keyboardType: TextInputType.emailAddress,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Type Your Issue Here',
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  sendRequest(context);
                  sent = true;
                },
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }

  Widget academicForm() {
    return Column(
      children: <Widget>[
        Container(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "Success. Response in 4 to 6 days",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        _switcher == 0
            ? Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    controller: regController,
                    cursorColor: Colors.grey[600],
                    cursorWidth: 3.0,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Registration Number',
                      hintStyle: TextStyle(color: Colors.grey[500]),
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
              )
            : SizedBox(),
        /*Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextField(
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
            controller: collegeController,
            cursorColor: Colors.grey[600],
            cursorWidth: 3.0,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'College',
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
        ),*/
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
                          value: val["id"].toString(),
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
                      /*setState(() {
                                                  _dropDownValue = val;
                                                });*/
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.grey[600], fontSize: 15),

            controller: issueController,
            cursorColor: Colors.white,
            cursorWidth: 3.0,
            //keyboardType: TextInputType.emailAddress,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'State details here',
              hintStyle: TextStyle(color: Colors.grey[500]),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  sendRequest(context);
                  sent = true;
                },
                color: Colors.blue,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }

  Widget accomodationForm() {
    return Column(
      children: <Widget>[
        Container(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "Success. Response in 4 to 6 days",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 18),
              controller: regController,
              cursorColor: Colors.grey[600],
              cursorWidth: 3.0,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Registration Number',
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
          child: TextField(
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
            controller: collegeController,
            cursorColor: Colors.grey[600],
            cursorWidth: 3.0,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'College',
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
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextField(
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
            controller: schoolController,
            cursorColor: Colors.grey[600],
            cursorWidth: 3.0,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'School',
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
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.grey[600], fontSize: 15),

            controller: issueController,
            cursorColor: Colors.white,
            cursorWidth: 3.0,
            //keyboardType: TextInputType.emailAddress,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Type Your Issue Here',
              hintStyle: TextStyle(color: Colors.grey[500]),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  sendRequest(context);
                  sent = true;
                },
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }

  Widget appForm() {
    return Column(
      children: <Widget>[
        Container(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "Success. Response in 4 to 6 days",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.grey[600], fontSize: 15),

            controller: issueController,
            cursorColor: Colors.white,
            cursorWidth: 3.0,
            //keyboardType: TextInputType.emailAddress,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Type Your Issue Here',
              hintStyle: TextStyle(color: Colors.grey[500]),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  sendRequest(context);
                  sent = true;
                },
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }

  Widget othersForm() {
    return Column(
      children: <Widget>[
        Container(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "Success. Response in 4 to 6 days",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.grey[600], fontSize: 15),

            controller: issueController,
            cursorColor: Colors.white,
            cursorWidth: 3.0,
            //keyboardType: TextInputType.emailAddress,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Type Your Issue Here',
              hintStyle: TextStyle(color: Colors.grey[500]),
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
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            child: RaisedButton(
                elevation: 0,
                onPressed: () {
                  sendRequest(context);
                  sent = true;
                },
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
