import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ftoast/ftoast.dart';
import 'package:radauon/screens/dashboard.dart';
import 'package:radauon/screens/password_reset.dart';
import 'package:radauon/screens/studentauth.dart';
import 'package:radauon/services/authentication.dart';
import 'package:state_persistence/state_persistence.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  LoginScreen({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  double _width = 0;
  final _formKey = GlobalKey<FormState>();
  bool _passpasswordVisible = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool _showProgress = false;

  bool _showButton = true;

  void initState() {
    super.initState();
    PersistedStateBuilder(
      builder: (BuildContext context, AsyncSnapshot<PersistedData> snapshot) {
        snapshot.data["synced"] = true;
        return SizedBox(
          height: 0,
          width: 0,
        );
      },
    );
    _updatestate();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
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
                                                controller: emailController,
                                                cursorColor: Colors.red,
                                                cursorWidth: 3.0,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[100],
                                                  hintText: 'Email Address',
                                                  //prefixIcon: Icon(Icons.search,color: Colors.grey[400],size: 27,),
                                                  suffixIcon: Icon(
                                                    Icons.email,
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
                                                        "LOGIN",
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
                                                        if (emailController
                                                                .text.isEmpty ||
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
                                                        } else if (emailController
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
                                                        _login(
                                                            emailController.text
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
                                            GestureDetector(
                                              onTap: () {
                                                /*Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .slideInRight,
                                                        child: SignupScreen()));*/
                                                Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .slideInRight,
                                                        child: StudentAuth()));
                                              },
                                              child: Text(
                                                "CREATE ACCOUNT",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                /*Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .slideInRight,
                                                        child: SignupScreen()));*/
                                                Navigator.of(context).push(
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .slideInRight,
                                                        child: StudentAuth()));
                                              },
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Reset(),
                                                      ));
                                                },
                                                child: Text(
                                                  "FORGOT PASSWORD?",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
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

  Future<String> signInUser(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    FirebaseUser user = result.user;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard(id: result.user.uid)),
      );
    } else {
      print("This user does not exist");
    }

    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    var userid = user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> _login(String email, String password) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      //FirebaseUser user = result.user;
      if (result != null) {
        var tokensReference = Firestore.instance
            .collection('DeviceTokens')
            .document(result.user.uid);

        _firebaseMessaging.getToken().then((deviceToken) {
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              tokensReference,
              {'device': deviceToken},
            );
          });
        }).then((value) {
          setState(() {
            _showButton = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashBoard(id: result.user.uid)),
            );
          });
        });
      }
    } catch (e) {
      setState(() {
        _showButton=true;
      });
      if (e.toString() ==
          "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)") {
        setState(() {
          _showButton = true;
        });

        if(Platform.isIOS){
          FToast.toast(
            context,
            msg: "User does not exist",
            duration: 1500,
          );
        }

        Flushbar(
          title: "Login Failed",
          message: "User does not exist",
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30,
          ),
          duration: Duration(seconds: 3),
          isDismissible: false,
        )..show(context);
      } else if (e.toString() ==
          "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
        setState(() {
          _showButton = true;
        });

        if(Platform.isIOS){
          FToast.toast(
            context,
            msg: "No internet connection",
            duration: 1500,
          );
        }

        Flushbar(
          title: "Login Failed",
          message: "No internet connection",
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30,
          ),
          duration: Duration(seconds: 3),
          isDismissible: false,
        )..show(context);
        //BotToast.showSimpleNotification(title: "No internet connection");
      } else if (e.toString() ==
          "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)") {


        setState(() {
          _showButton = true;
        });

        if(Platform.isIOS){
          FToast.toast(
            context,
            msg: "You entered the wrong password",
            duration: 1500,
          );
        }

        Flushbar(
          title: "Login Failed",
          message: "You entered the wrong password",
          duration: Duration(seconds: 3),
          isDismissible: true,
          flushbarPosition: FlushbarPosition.TOP,
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.redAccent,
        )..show(context);
      } else if (e.toString() ==
          "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)") {

        setState(() {
          _showButton = true;
        });

        if(Platform.isIOS){
          FToast.toast(
            context,
            msg: "You entered the wrong email",
            duration: 1500,
          );
        }

        Flushbar(
          title: "Login Failed",
          message: "You entered the wrong email",
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30,
          ),
          duration: Duration(seconds: 3),
          isDismissible: false,
        )..show(context);
        //BotToast.showSimpleNotification(title: "Wrong email");
      }

      //print(e.toString());
    }
  }
}
