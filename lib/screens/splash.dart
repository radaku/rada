import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radauon/screens/dashboard.dart';
import 'package:radauon/screens/login_screen.dart';
import 'package:state_persistence/state_persistence.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DashBoard(
                    id: user.uid,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return;
      },
      child: PersistedAppState(
        storage: JsonFileStorage(),
        child: new Scaffold(
          //backgroundColor: Color(0xff1979a9),
          backgroundColor: Colors.white.withAlpha(210),
          body: new Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            /*child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    */ /*child: new CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),*/ /*
                    child: circularProgress(),
                  ),
                ],
              ),
            ),*/
          ),
        ),
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
              color: Colors.amber),
        );
      },
    );

    //SpinKitThreeBounce
  }
}
