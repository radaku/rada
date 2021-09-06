import 'dart:async';

import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';

import 'package:radauon/widgets/slide_item.dart';

import 'package:radauon/model/slide.dart';


import 'package:radauon/widgets/slide_dots.dart';

import 'package:radauon/screens/login_screen.dart';
import 'package:radauon/screens/signup_screen.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1979a9),
      body: Container(
        color: Color(0xff1979a9),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(15),
                    /*color: Theme.of(context).primaryColor,*/
                    color: Color(0xff195e83),
                    textColor: Colors.white,
                    onPressed: () {
                      //Navigator.of(context).pushNamed(SignupScreen.routeName);
                      Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInRight, child: SignupScreen()));

                      /*Navigator.push(
                        context,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 700),
                          exitPage: widget,
                          enterPage: SignupScreen(),
                          transition: CubeTransition(),
                        ),
                      );*/

                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Have an account?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                        onPressed: () {
                          //Navigator.of(context).pushNamed(LoginScreen.routeName);
                          Navigator.push(
                            context,
                            AwesomePageRoute(
                              transitionDuration: Duration(milliseconds: 700),
                              exitPage: widget,
                              enterPage: LoginScreen(),
                              transition: CubeTransition(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
