import 'dart:convert';
import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/lastreg.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];

  final List<Map> imgList = [];
  final List<Map> newsList = [];
  Map news;

  final List<Map> imgList1 = [];
  final List<Map> newsList1 = [];
  Map news1;

  String _color = '';

  var _dropDownValue;

  var _dropDownValue3;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool fetched = false;
  bool campusfetched = false;

  int uni_id;

  String campus_id;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUniversities();
  }

  void getUniversities() async {
    newsList.clear();
    newsList1.clear();
    print('Fetching Contacts...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/university/get',
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
    fetched = true;
    //print(newsList);
  }

  void getCampuses(int id) async {
    newsList1.clear();
    print('Fetching Contacts...');
    http.Response response = await http.get(
        'http://rada.uonbi.ac.ke/radaweb/api/campuses/get/$id',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    for (var i = 0; i < convert.length; i++) {
      news1 = convert[i];
      setState(() {
        newsList1.add(news1);
      });
    }

    for (var i = 0; i < newsList1.length; i++) {
      imgList1.add(newsList1[i]);
      //print(imgList);
    }
    campusfetched = true;
    //print(newsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //backgroundColor: Color(0xff1979a9),
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
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/curve.png'),
                  fit: BoxFit.cover),
              //color: Color(0xff195e83),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 280),
              child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    children: <Widget>[
                      Neumorphic(
                        margin: EdgeInsets.only(top: 7),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(5)),
                            depth: 0,
                            lightSource: LightSource.topLeft,
                            color: Colors.grey[100]),
                        child: TextField(
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 15, right: 15),
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: 'User Name',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            focusedBorder: OutlineInputBorder(
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
                      Neumorphic(
                        margin: EdgeInsets.only(top: 7),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(5)),
                            depth: 0,
                            lightSource: LightSource.topLeft,
                            color: Colors.grey),
                        child: TextField(
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                          controller: emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 15, right: 15),
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: 'Email Address',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            focusedBorder: OutlineInputBorder(
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
                      Neumorphic(
                        margin: EdgeInsets.only(top: 7),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(5)),
                            depth: 0,
                            lightSource: LightSource.topLeft,
                            color: Colors.grey[100]),
                        child: TextField(
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                          controller: phoneController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 15, right: 15),
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            focusedBorder: OutlineInputBorder(
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
                      fetched == false
                          ? SizedBox()
                          : Container(
                              height: 60,
                              child: Neumorphic(
                                margin: EdgeInsets.only(top: 7),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(5)),
                                    depth: 0,
                                    lightSource: LightSource.topLeft,
                                    color: Colors.grey[100]),
                                child: FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            // borderSide: BorderSide(color: Colors.grey[200]),
                                            borderSide: BorderSide(
                                                color: Colors.grey[100]),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[100]),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 5, left: 10, bottom: 5)),
                                      isEmpty: _color == '',
                                      child: new DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          focusColor: Colors.grey[100],
                                          hint: _dropDownValue == null
                                              ? Text(
                                                  'Select University',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          'Raleway-regular',
                                                      fontSize: 18),
                                                )
                                              : Text(
                                                  _dropDownValue,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          'Raleway-regular',
                                                      fontSize: 18),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                          items: newsList.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val["id"].toString(),
                                                child: Text(val["name"]),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            getCampuses(int.parse(val));
                                            newsList.forEach((element) {
                                              if (element["id"].toString() ==
                                                  val) {
                                                setState(() {
                                                  _dropDownValue =
                                                      element["name"];
                                                });
                                              }
                                            });
                                            /*setState(() {
                                              _dropDownValue = val;
                                            });*/
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      campusfetched == false
                          ? SizedBox()
                          : Container(
                              height: 60,
                              child: Neumorphic(
                                margin: EdgeInsets.only(top: 7),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(5)),
                                    depth: 0,
                                    lightSource: LightSource.topLeft,
                                    color: Colors.grey[100]),
                                child: FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            // borderSide: BorderSide(color: Colors.grey[200]),
                                            borderSide: BorderSide(
                                                color: Colors.grey[100]),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[100]),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 5, left: 10, bottom: 5)),
                                      isEmpty: _color == '',
                                      child: new DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          hint: _dropDownValue3 == null
                                              ? Text(
                                                  'Select Campus',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          'Raleway-regular',
                                                      fontSize: 18),
                                                )
                                              : Text(
                                                  _dropDownValue3,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily:
                                                          'Raleway-regular',
                                                      fontSize: 18),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: TextStyle(color: Colors.black),
                                          items: newsList1.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val['id'].toString(),
                                                child: Text(val["name"]),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            newsList1.forEach((element) {
                                              if (element["id"].toString() ==
                                                  val) {
                                                setState(() {
                                                  _dropDownValue3 =
                                                      element["name"];
                                                });

                                                setState(() {
                                                  campus_id = val;
                                                });
                                              }
                                            });
                                            /*setState(() {
                                              _dropDownValue3 = val;
                                            });*/
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      campusfetched == false
                          ? SizedBox()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                child: ArgonButton(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: 0.0,
                                  color: Color(0xff1979A9),
                                  roundLoadingShape: true,
                                  elevation: 0,
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Raleway-regular',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  loader: Container(
                                    padding: EdgeInsets.all(10),
                                    child: SpinKitRipple(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading, btnState) {
                                    startLoading();
                                    if (nameController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty &&
                                        phoneController.text.isNotEmpty &&
                                        _dropDownValue != null &&
                                        _dropDownValue3 != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupScreen2(
                                                name: nameController.text,
                                                email: emailController.text,
                                                phone: phoneController.text,
                                                university: _dropDownValue,
                                                campus: campus_id)),
                                      );
                                    } else {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("All fields are required"),
                                        backgroundColor: Colors.green,
                                      ));
                                    }

                                    stopLoading();
                                  },
                                ),
                              ),
                            ),
                    ],
                  )),
            )),
      ),
    );
  }
}
