import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/ProfileHelper/profile.helper.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            EvaIcons.settings2Outline,
            color: blueColor,
          ),
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
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: [
                TextSpan(
                  text: 'Profile',
                  style: TextStyle(
                    color: blueColor,
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
