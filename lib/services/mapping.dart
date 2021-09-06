import 'package:flutter/material.dart';
import 'package:radauon/screens/home.dart';
import 'package:radauon/screens/login_screen.dart';
import 'package:radauon/services/authentication.dart';

class MappingPage extends StatefulWidget {

  final AuthImplementation auth;
  MappingPage({
    this.auth,
  });

  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {

  AuthStatus authStatus=AuthStatus.notSignedIn;

  void initState(){
    super.initState();
    widget.auth.getCurrentUser().then((firebseUserId){
      setState(() {
        authStatus=firebseUserId==null?AuthStatus.notSignedIn:AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }


  void _signedOut(){
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return new LoginScreen(
          auth:widget.auth,
          onSignedIn:_signedIn
        );
      case AuthStatus.signedIn:
        return new HomePage(
            /*auth:widget.auth,
            onSignedOut:_signedOut*/
        );
    }
    return null;
  }
}



