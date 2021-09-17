import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class GroupMessageHelper extends ChangeNotifier {
  showMessages(
      {@required BuildContext context,
      @required DocumentSnapshot documentSnapshot,
      @required String adminUserUid}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return new ListView(
            reverse: true,
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              decoration: BoxDecoration(
                                color: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot.data()['userUid']
                                    ? blueGreyColor.withOpacity(0.8)
                                    : blueGreyColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot.data()['userName'],
                                            style: TextStyle(
                                              color: greenColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserUid ==
                                                  adminUserUid
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    size: 12,
                                                    color: yellowColor,
                                                  ),
                                                )
                                              : Container(
                                                  width: 0,
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot.data()['message'],
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        child:
                            Provider.of<Authentication>(context, listen: false)
                                        .getUserUid ==
                                    documentSnapshot.data()['userUid']
                                ? Container(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: blueColor,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.trashAlt,
                                            color: redColor,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                      ),
                      Positioned(
                          left: 40,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot.data()['userUid']
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : CircleAvatar(
                                  backgroundColor: darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userImage']),
                                ))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  sendMessage(
      {@required BuildContext context,
      @required DocumentSnapshot documentSnapshot,
      @required TextEditingController messageController}) {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
    });
  }
}
