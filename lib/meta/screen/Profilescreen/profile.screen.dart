import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/ProfileHelper/profile.helper.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                  child: HomeScreen(), type: PageTransitionType.rightToLeft),
            );
          },
          icon: Icon(Icons.arrow_back_ios_outlined, color: greenColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logoutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: greenColor,
            ),
          )
        ],
        backgroundColor: blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: 'My ',
              style: TextStyle(
                color: redColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: [
                TextSpan(
                  text: 'Profile',
                  style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return new Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .headerProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .status(context: context),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .middleProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .footerProfile(context, snapshot),
                    ],
                  );
                }
              },
            ),
            decoration: BoxDecoration(
                color: blueGreyColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
