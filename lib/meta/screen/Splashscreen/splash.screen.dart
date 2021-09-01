import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/meta/screen/Landingscreen/landing.screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
            child: LandingPage(), type: PageTransitionType.leftToRight),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'social',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
              children: [
                TextSpan(
                  text: 'Tower',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34.0),
                ),
              ]),
        ),
      ),
    );
  }
}
