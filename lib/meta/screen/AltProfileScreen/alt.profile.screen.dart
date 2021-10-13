import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/AltScreenHelpers/alt.profile.helper.dart';

class AltProfile extends StatelessWidget {
  final String userUid;

  const AltProfile({Key key, @required this.userUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AltProfileHelper>(context, listen: false).appBar(
        context: context,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .headerProfile(
                      context: context,
                      snapshot: snapshot,
                      userUid: userUid,
                    ),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .status(context: context, userUid: userUid),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .middleProfile(context: context, snapshot: snapshot),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .footerProfile(context: context, snapshot: snapshot)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
