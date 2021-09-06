import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radauon/screens/splash.dart';

void main() {
  /*SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });*/
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/error.png'),
              SizedBox(
                height: 30,
              ),
              Text("Oops!, something went wrong")
            ],
          ),
        ),
      );
  runApp(WelcomePage());
}

class WelcomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /*home: GettingStartedScreen(),*/
      home: SplashScreen(),
      /*routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
      },*/
    );
  }
}
