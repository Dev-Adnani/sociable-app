import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class GroupMessageHelper extends ChangeNotifier {
  final TextEditingController editMessageController = TextEditingController();

  showMessages(
      {@required BuildContext context,
      @required DocumentSnapshot documentSnapshots,
      @required String adminUserUid}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          .doc(documentSnapshots.id)
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
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
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
                                    documentSnapshot.data()['messageEdited'] ==
                                            1
                                        ? Text(
                                            'edited',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        child: Provider.of<Authentication>(context,
                                        listen: false)
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
                                        onPressed: () async {
                                          return showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: blueGreyColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        topRight:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 300,
                                                            height: 50,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          12.0),
                                                              child: TextField(
                                                                controller:
                                                                    editMessageController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Edit your Message',
                                                                  hintStyle: TextStyle(
                                                                      color:
                                                                          whiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            ),
                                                          ),
                                                          FloatingActionButton(
                                                            backgroundColor:
                                                                blueColor,
                                                            child: Icon(
                                                              Icons.send,
                                                              color: whiteColor,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (editMessageController
                                                                  .text
                                                                  .isEmpty) {
                                                                Provider.of<LandingService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .warningText(
                                                                        context,
                                                                        'Please Type Something In Order To Edit',
                                                                        16.0);
                                                              } else {
                                                                print(
                                                                    'edit 1 : ${editMessageController.text}');
                                                                await Provider.of<
                                                                            FirebaseNotifier>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .updateMessage(
                                                                        messageID:
                                                                            documentSnapshot
                                                                                .id,
                                                                        roomID: documentSnapshots.data()[
                                                                            'roomID'],
                                                                        data: {
                                                                      'message':
                                                                          editMessageController
                                                                              .text,
                                                                      'messageEdited':
                                                                          1,
                                                                    }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  editMessageController
                                                                      .clear();
                                                                });
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }),
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.trashAlt,
                                        color: redColor,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        Provider.of<FirebaseNotifier>(context,
                                                listen: false)
                                            .deleteMessage(
                                                messageID: documentSnapshot.id,
                                                roomID: documentSnapshots
                                                    .data()['roomID']);
                                      },
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
      'messageEdited': 0,
      'time': Timestamp.now(),
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
    });
  }
}
