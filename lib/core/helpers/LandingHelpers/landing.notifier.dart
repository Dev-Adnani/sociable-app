import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.utlis.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class LandingNotifier with ChangeNotifier {
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login.png')),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: 450.0,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300.0),
        child: RichText(
          text: TextSpan(
            text: 'Want ',
            style: TextStyle(
                fontFamily: 'Poppins',
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0),
            children: [
              TextSpan(
                text: 'To ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
              TextSpan(
                text: 'Climb ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
              TextSpan(
                text: 'The ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
              TextSpan(
                text: 'Tower ?',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 630.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.emailOutline,
                  color: yellowColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: yellowColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.leftToRight));
                  });
                } catch (e) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.google,
                  color: redColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: redColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(
                  EvaIcons.facebookOutline,
                  color: blueColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: blueColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 720.0,
      left: 20.0,
      right: 20.0,
      child: Container(
        child: Column(
          children: [
            Text(
              "By continuing you agree Social Tower's",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            ),
            Text(
              "Services & Privacy Policy",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            )
          ],
        ),
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: whiteColor,
                ),
              ),
              Provider.of<LandingService>(context, listen: false)
                  .passwordLessSignIn(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: blueColor,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<LandingService>(context, listen: false)
                          .loginSheet(context);
                    },
                  ),
                  MaterialButton(
                    color: redColor,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<LandingUtils>(context, listen: false)
                          .selectAvatarOptionsSheet(context);
                    },
                  ),
                ],
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
        );
      },
    );
  }
}
