import 'dart:convert';
import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/signup_screen.dart';

class StudentAuth extends StatefulWidget {
  @override
  _StudentAuthState createState() => _StudentAuthState();
}

class _StudentAuthState extends State<StudentAuth> {
  final regController = TextEditingController();
  final passwordController = TextEditingController();

  double _width = 0;
  final _formKey = GlobalKey<FormState>();
  bool _passpasswordVisible = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool _showProgress = false;

  bool _showButton = true;

  final List<Map> newsList = [];
  Map news;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    regController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  double _updatestate() {
    setState(() {
      _width = 325;
    });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Builder(builder: (ctx) {
          return Scaffold(
              //backgroundColor: Color(0xff195e83),
              backgroundColor: Colors.white,
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
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 100),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 50,
                                            ),

                                            SizedBox(
                                              height: 155,
                                            ),

                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 18),
                                                controller: regController,
                                                cursorColor: Colors.red,
                                                cursorWidth: 3.0,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  hintText:
                                                      'Registration Number',
                                                  //prefixIcon: Icon(Icons.search,color: Colors.grey[400],size: 27,),
                                                  suffixIcon: Icon(
                                                    Icons.check,
                                                    color: Colors.grey[400],
                                                    size: 27,
                                                  ),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500]),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 18,
                                                          bottom: 18,
                                                          left: 15,
                                                          right: 15),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    // borderSide: BorderSide(color: Colors.grey[200]),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[100]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[100]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                                controller: passwordController,
                                                obscureText:
                                                    _passpasswordVisible,
                                                cursorWidth: 3.0,
                                                cursorColor: Colors.red,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  hintText: 'Password',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500]),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 18,
                                                          bottom: 18,
                                                          left: 15,
                                                          right: 15),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    // borderSide: BorderSide(color: Colors.grey[200]),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[100]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[100]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  //labelText: 'Password',
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _passpasswordVisible
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      // Update the state i.e. toogle the state of passwordVisible variable
                                                      setState(() {
                                                        if (!_passpasswordVisible) {
                                                          _passpasswordVisible =
                                                              true;
                                                        } else if (_passpasswordVisible) {
                                                          _passpasswordVisible =
                                                              false;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            /*SizedBox(height: 20,),
                                            Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Text(
                                                  "Forgot Password?",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:'Raleway-regular',
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white
                                                  ),
                                                )
                                            ),*/
                                            SizedBox(
                                              height: 20,
                                            ),

                                            _showButton
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: ArgonButton(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      borderRadius: 0.0,
                                                      color: Color(0xff1979A9),
                                                      roundLoadingShape: true,
                                                      elevation: 0,
                                                      child: Text(
                                                        "Authenticate",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'Raleway-regular',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      loader: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: SpinKitDualRing(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onTap: (startLoading,
                                                          stopLoading,
                                                          btnState) {
                                                        setState(() {
                                                          _showButton = false;
                                                        });
                                                        //startLoading();
                                                        if (regController
                                                                .text.isEmpty ||
                                                            passwordController
                                                                .text.isEmpty) {
                                                          setState(() {
                                                            _showButton = true;
                                                          });
                                                          Flushbar(
                                                            title:
                                                                "Authentication Failed",
                                                            message:
                                                                "All fields are required",
                                                            icon: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                            duration: Duration(
                                                                seconds: 3),
                                                            isDismissible:
                                                                false,
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          )..show(context);
                                                        } else if (regController
                                                                .text.isEmpty &&
                                                            passwordController
                                                                .text.isEmpty) {
                                                          setState(() {
                                                            _showButton = true;
                                                          });
                                                          Flushbar(
                                                            title:
                                                                "Login Failed",
                                                            message:
                                                                "All fields are required",
                                                            icon: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                            duration: Duration(
                                                                seconds: 3),
                                                            isDismissible:
                                                                false,
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          )..show(context);
                                                        }
                                                        _authenticate(
                                                            regController.text
                                                                .trim(),
                                                            passwordController
                                                                .text
                                                                .trim());

                                                        //stopLoading();
                                                      },
                                                    ),
                                                  )
                                                : circularProgress(),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),

                                            //_showProgress==true?circularProgress():SizedBox(width: 1,height: 1,)
                                          ]),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ));
        }),
      ),
    );
  }

  void _authenticate(String regno, String password) async {
    http.Response response = await http.get(
        'https://smis.uonbi.ac.ke/authenticate_student.php?student_id=${regno.trim()}&password=${password}',
        headers: {"Accept": "application/json"});

    var convert = await json.decode(response.body);
    if (convert["status"] == "CURRENT") {
      setState(() {
        _showButton = true;
      });
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.slideInRight, child: SignupScreen()));
    } else if (convert["status"] == "WRONG PASSWORD") {
      setState(() {
        _showButton = true;
      });
      Flushbar(
        title: "Authentication Failed",
        message: "Wrong password",
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 30,
        ),
        duration: Duration(seconds: 3),
        isDismissible: false,
        backgroundColor: Colors.redAccent,
      )..show(context);
    } else if (convert["status"] == "NOT CURRENT") {
      setState(() {
        _showButton = true;
      });
      Flushbar(
        title: "Authentication Failed",
        message: "Not a current student",
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 30,
        ),
        duration: Duration(seconds: 3),
        isDismissible: false,
        backgroundColor: Colors.redAccent,
      )..show(context);
    }
    //print(convert["status"]);
    /*for (var i = 0; i < convert.length; i++) {
      news = convert[i];
      setState(() {
        newsList.add(news);
      });
    }*/
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
