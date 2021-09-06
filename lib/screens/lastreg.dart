import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:radauon/screens/dashboard.dart';
import 'package:radauon/utils/details_helper.dart';
import 'package:toast/toast.dart';

class SignupScreen2 extends StatefulWidget {
  static const routeName = '/signup';

  final String name;
  final String email;
  final String phone;
  final String university;
  final String campus;

  SignupScreen2(
      {Key key,
      @required this.name,
      this.email,
      this.phone,
      this.university,
      this.campus})
      : super(key: key);

  @override
  _SignupScreen2State createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];

  String _color = '';

  var _selectedDate;

  var _dropDownValue2;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  DetailsHelper detailsHelper;

  bool _showButton = true;
  File _image;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailsHelper = DetailsHelper();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xff1979a9),
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/curve.png'),
                fit: BoxFit.cover),
            //color: Color(0xff195e83),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: new Form(
                key: _formKey,
                autovalidate: true,
                child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 7, left: 10),
                      child: Text(
                        "Choose Date Of Birth",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: 'Raleway-regular'),
                      ),
                    ),
                    Neumorphic(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(5)),
                          depth: 0,
                          lightSource: LightSource.topLeft,
                          color: Colors.grey[100]),
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DatePickerWidget(
                            looping: false, // default is not looping
                            firstDate: DateTime(1960),
                            lastDate: DateTime(2020, 1, 1),
                            initialDate: DateTime(1990, 2, 2),
                            dateFormat: "dd-MMMM-yyyy",
                            onChange: (DateTime newDate, _) =>
                                _selectedDate = newDate,
                            pickerTheme: DateTimePickerTheme(
                                itemTextStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 19,
                                    fontFamily: 'Raleway-regular')),
                          ),
                        ),
                      ),
                    ),
                    Neumorphic(
                      margin: EdgeInsets.only(top: 7, left: 10, right: 10),
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
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                contentPadding: EdgeInsets.only(
                                    top: 5, left: 10, bottom: 5)),
                            isEmpty: _color == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: _dropDownValue2 == null
                                    ? Text('Select Gender',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway-regular',
                                            fontSize: 18))
                                    : Text(
                                        _dropDownValue2,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway-regular',
                                            fontSize: 18),
                                      ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: TextStyle(color: Colors.grey[600]),
                                items: ['Male', 'Female', 'unspecified'].map(
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
                    Neumorphic(
                      margin: EdgeInsets.only(top: 7, right: 10, left: 10),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(5)),
                          depth: 0,
                          lightSource: LightSource.topLeft,
                          color: Colors.grey[100]),
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.all(15),
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
                      margin: EdgeInsets.only(top: 7, left: 10, right: 10),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(5)),
                          depth: 0,
                          lightSource: LightSource.topLeft,
                          color: Colors.grey[100]),
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        controller: confirmController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.all(15),
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
                    Container(
                      margin: EdgeInsets.only(top: 7, left: 10, right: 10),
                      child: _showButton
                          ? ArgonButton(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              borderRadius: 0.0,
                              color: Color(0xff1979A9),
                              elevation: 0,
                              roundLoadingShape: true,
                              child: Text(
                                "SignUp",
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
                                setState(() {
                                  _showButton = false;
                                });
                                //startLoading();
                                /*if(passwordController.text==confirmController.text){
                            _signup(widget.email, passwordController.text);
                          }else{
                            print("Passwords do not match");
                          }*/
                                if (confirmController.text ==
                                        passwordController.text &&
                                    _dropDownValue2 != null) {
                                  _signup(widget.email.trim(),
                                      passwordController.text.trim());
                                } else {
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Passwords do not match or you missed a field"),
                                    backgroundColor: Colors.green,
                                  ));
                                }
                              },
                            )
                          : circularProgress(),
                    ),
                  ],
                )),
          )),
    );
  }

  Future<String> _signup(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (result != null) {
        var documentReference =
            Firestore.instance.collection('Users').document(user.uid);

        var tokensReference =
            Firestore.instance.collection('DeviceTokens').document(user.uid);

        await Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'user_id': user.uid,
              'email': widget.email,
              'joined': DateTime.now().millisecondsSinceEpoch.toString(),
              'name': widget.name,
              'user_type': "user",
              'phone': widget.phone,
              'university': widget.university,
              'campus': widget.campus,
              'gender': _dropDownValue2,
              'image': 'https://wishnget.biz/rimages/glasses.jpg',
              'synced': false,
              "mentorship_status": false
            },
          );
        }).then((value) {
          storeToMysql(user.uid);
          _firebaseMessaging.getToken().then((deviceToken) {
            Firestore.instance.runTransaction((transaction) async {
              await transaction.set(
                tokensReference,
                {'device': deviceToken},
              );
            });
          });
          setState(() {
            detailsHelper.save({
              "synced": "0",
              "user_id": result.user.uid,
              "user_type": "user",
              "created_at": DateTime.now().millisecondsSinceEpoch.toString()
            }).then((value) {
              _showButton = true;
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => DashBoard(id: result.user.uid)));
            });
          });
        });
      }
    } catch (e) {
      if (e.toString() ==
          "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
        setState(() {
          _showButton = true;
        });
        Toast.show("request has timed out", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.deepOrange,
            backgroundRadius: 5,
            textColor: Colors.black);
      } else if (e.toString() ==
          "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
        setState(() {
          _showButton = true;
        });
        Toast.show("no internet connection", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.amber,
            backgroundRadius: 5,
            textColor: Colors.black);
      }
      print(e.toString());
    }

    //return user.uid;
  }

  void storeToMysql(String userid) async {
    //Mysql Part Start
    http.Response response = await http
        .post('http://rada.uonbi.ac.ke/radaweb/api/api/user/signup', headers: {
      "Accept": "application/json"
    }, body: {
      "user_id": userid,
      "name": widget.name,
      "dob": DateTime.now().toString(),
      "image": "user_image",
      "account_status": "1",
      "email": widget.email,
      "campus_id": widget.campus,
      "joined": DateTime.now().toString(),
      "phone_id":
          "SCVBSCBW8E8R9EWRF8R8FUSDJSKVPOXDBUR8EREBVUDFYEUREFYRREUREFHBD8E89E",
      "phone": widget.phone.toString(),
      "gender": _dropDownValue2.toString(),
      "mentorship_status": "false"
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

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("Device token is : " + deviceToken);
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
