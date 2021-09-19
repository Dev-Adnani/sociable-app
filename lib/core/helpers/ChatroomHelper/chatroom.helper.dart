import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:nanoid/nanoid.dart';
import 'package:social_tower/meta/screen/AltProfilescreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/GroupMessagescreen/groupmessage.screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier {
  String chatRoomAvatarUrl, chatroomID;
  String get getChatroomAvatarUrl => chatRoomAvatarUrl;
  String get getChatroomID => chatroomID;
  String latestMessageTime;
  String get getLatestMessageTime => latestMessageTime;

  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(
      {BuildContext context, DocumentSnapshot documentSnapshot}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: whiteColor,
                    thickness: 4,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: blueColor),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(documentSnapshot.data()['roomID'])
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    documentSnapshot.data()['userUid']) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid: documentSnapshot
                                                  .data()['userUid']),
                                          type:
                                              PageTransitionType.leftToRight));
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: darkColor,
                                  backgroundImage: NetworkImage(
                                    documentSnapshot.data()['userImage'],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: yellowColor),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: transperant,
                          backgroundImage: NetworkImage(
                              documentSnapshot.data()['userImage']),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                documentSnapshot.data()['userName'],
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            documentSnapshot.data()['userUid'] ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: darkColor,
                                                title: Text(
                                                  'Are you sure ? You Want To Delete ?',
                                                  style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              whiteColor,
                                                          fontSize: 14.0),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    color: redColor,
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'chatroom')
                                                          .doc(documentSnapshot
                                                              .id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Text(
                                        'Delete Chatroom',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  showCreateChatroomSheet({BuildContext context}) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: darkColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: whiteColor,
                      thickness: 4,
                    ),
                  ),
                  Text(
                    'Select Chat room Avatar',
                    style: TextStyle(
                      color: greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rewards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatRoomAvatarUrl =
                                      documentSnapshot.data()['image'];
                                  print('chatroom url = > $chatRoomAvatarUrl');
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: chatRoomAvatarUrl ==
                                                  documentSnapshot
                                                      .data()['image']
                                              ? blueColor
                                              : transperant),
                                    ),
                                    height: 10.0,
                                    width: 40.0,
                                    child: Image.network(
                                        documentSnapshot.data()['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom Id',
                            hintStyle: TextStyle(
                                color: whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plusCircle,
                          color: yellowColor,
                        ),
                        onPressed: () async {
                          var randomID = nanoid(6);
                          if (chatroomNameController.text.isNotEmpty &&
                              chatRoomAvatarUrl.isNotEmpty) {
                            Provider.of<FirebaseNotifier>(context,
                                    listen: false)
                                .submitChatroomData(
                              chatRoomID: randomID,
                              chatRoomData: {
                                'roomAvatar': getChatroomAvatarUrl,
                                'roomID': randomID,
                                'time': Timestamp.now(),
                                'roomName': chatroomNameController.text,
                                'userName': Provider.of<FirebaseNotifier>(
                                        context,
                                        listen: false)
                                    .getInitUserName,
                                'userEmail': Provider.of<FirebaseNotifier>(
                                        context,
                                        listen: false)
                                    .getInitUserEmail,
                                'userImage': Provider.of<FirebaseNotifier>(
                                        context,
                                        listen: false)
                                    .getInitUserImage,
                                'userUid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                              },
                            ).whenComplete(() {
                              var randomMessageID = nanoid(5);
                              FirebaseFirestore.instance
                                  .collection('chatroom')
                                  .doc(randomID)
                                  .collection('messages')
                                  .doc(randomMessageID)
                                  .set({
                                'messageID': randomID,
                                'message': 'Welcome To The Group',
                                'messageEdited': 0,
                                'time': Timestamp.now(),
                                'userUid': '0000',
                                'userName': 'Server',
                                'userImage':
                                    'https://firebasestorage.googleapis.com/v0/b/social-tower.appspot.com/o/rewards%2Fappicon.png?alt=media&token=6665f030-1aaa-4ed7-a7c4-2c1b1705b1b3',
                                'messageDeleted': 0
                              });
                              Navigator.pop(context);
                            });
                          } else {
                            Provider.of<LandingService>(context, listen: false)
                                .warningText(
                                    context,
                                    'Select ChatRoom Avatar & Add ChatRoom ID',
                                    16.0);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showChatrooms({BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatroom').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          return new ListView(
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: GroupMessage(documentSnapshot: documentSnapshot),
                        type: PageTransitionType.leftToRight),
                  );
                },
                onLongPress: () {
                  showChatroomDetails(
                      context: context, documentSnapshot: documentSnapshot);
                },
                trailing: Container(
                  width: 80.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(documentSnapshot.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      showLastMessageTime(
                          snapshot.data.docs.first.data()['time']);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Text(
                          getLatestMessageTime,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: transperant,
                  backgroundImage:
                      NetworkImage(documentSnapshot.data()['roomAvatar']),
                ),
                title: Text(
                  documentSnapshot.data()['roomName'],
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
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
                    } else if (snapshot.data.docs.first.data()['userName'] !=
                            null &&
                        snapshot.data.docs.first.data()['message'] != null) {
                      return Text(
                        '${snapshot.data.docs.first.data()['userName']} : ${snapshot.data.docs.first.data()['message']}',
                        style: TextStyle(
                            color: greenColor,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.data.docs.first.data()['userName'] !=
                            null &&
                        snapshot.data.docs.first.data()['sticker'] != null) {
                      return Text(
                        '${snapshot.data.docs.first.data()['userName']} : Sticker',
                        style: TextStyle(
                            color: greenColor,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Text(
                        'No Message',
                        style: TextStyle(
                            color: greenColor,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
  }
}
