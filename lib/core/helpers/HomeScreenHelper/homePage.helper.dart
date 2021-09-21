import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class HomePageHelpers with ChangeNotifier {
  Widget bottomNavBar(
      int index, PageController pageController, BuildContext context) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: blueColor,
      unSelectedColor: whiteColor,
      strokeColor: blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(
          icon: Icon(Icons.search),
        ),
        CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35.0,
            backgroundColor: blueGreyColor,
            backgroundImage:
                Provider.of<FirebaseNotifier>(context, listen: false)
                            .getInitUserImage ==
                        null
                    ? AssetImage('assets/images/loading.png')
                    : NetworkImage(
                        Provider.of<FirebaseNotifier>(context, listen: false)
                            .getInitUserImage),
          ),
        ),
      ],
    );
  }
}
