import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.notifier.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LandingNotifier>(context, listen: false);
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          provider.bodyImage(context),
          provider.taglineText(context),
          provider.mainButton(context),
          provider.privacyText(context)
        ],
      ),
    );
  }

  Widget bodyColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.9],
            colors: [darkColor, blueGreyColor]),
      ),
    );
  }
}
