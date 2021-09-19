import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:nanoid/nanoid.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper extends ChangeNotifier {
  bool hasMemberJoined = false;
  String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;
  bool get getHasMemberJoined => hasMemberJoined;
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
              showLastMessage(time: documentSnapshot.data()['time']);
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  height: documentSnapshot.data()['message'] != null
                      ? MediaQuery.of(context).size.height * 0.12
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: documentSnapshot.data()['message'] !=
                                        null
                                    ? MediaQuery.of(context).size.width * 0.8
                                    : MediaQuery.of(context).size.width * 0.9,
                                maxHeight: documentSnapshot.data()['message'] !=
                                        null
                                    ? MediaQuery.of(context).size.height * 0.1
                                    : MediaQuery.of(context).size.height * 0.4,
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
                                    documentSnapshot.data()['message'] != null
                                        ? Text(
                                            documentSnapshot.data()[
                                                        'messageDeleted'] ==
                                                    1
                                                ? 'Message Deleted'
                                                : documentSnapshot
                                                    .data()['message'],
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: documentSnapshot.data()[
                                                          'messageDeleted'] ==
                                                      1
                                                  ? 10
                                                  : 14,
                                              fontWeight: documentSnapshot
                                                              .data()[
                                                          'messageDeleted'] ==
                                                      1
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                  documentSnapshot
                                                      .data()['sticker']),
                                            ),
                                          ),
                                    Container(
                                      width: 80.0,
                                      child: Text(
                                        getLastMessageTime,
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 8.0,
                                        ),
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
                        top: documentSnapshot.data()['messageDeleted'] == 0
                            ? 15
                            : 0,
                        child: Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid ==
                                documentSnapshot.data()['userUid']
                            ? Container(
                                child: Column(
                                  children: [
                                    documentSnapshot.data()['messageDeleted'] ==
                                            0
                                        ? IconButton(
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
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          12.0),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        editMessageController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Edit your Message',
                                                                      hintStyle: TextStyle(
                                                                          color:
                                                                              whiteColor,
                                                                          fontWeight: FontWeight
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
                                                                  color:
                                                                      whiteColor,
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
                                                                    await Provider.of<FirebaseNotifier>(context, listen: false).updateMessage(
                                                                        messageID:
                                                                            documentSnapshot
                                                                                .id,
                                                                        roomID: documentSnapshots.data()[
                                                                            'roomID'],
                                                                        data: {
                                                                          'message':
                                                                              editMessageController.text,
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
                                            })
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                    documentSnapshot.data()['messageDeleted'] ==
                                            0
                                        ? IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: redColor,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              Provider.of<FirebaseNotifier>(
                                                      context,
                                                      listen: false)
                                                  .deleteMessage(
                                                      messageID:
                                                          documentSnapshot.id,
                                                      roomID: documentSnapshots
                                                          .data()['roomID'],
                                                      data: {
                                                    'messageEdited': 0,
                                                    'messageDeleted': 1,
                                                  });
                                            },
                                          )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                  ],
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                      ),
                      Positioned(
                          left: 10,
                          top: 1.5,
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

  Future checkIfJoined(
      {@required BuildContext context,
      @required String chatRoomName,
      @required String chatRoomAdminUid}) async {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Inital state => $hasMemberJoined');
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
      if (value.data()['joined'] != null) {
        hasMemberJoined = value.data()['joined'];
        print('Final state => $hasMemberJoined');
        notifyListeners();
      }
    });
  }

  leaveTheRoom(
      {@required BuildContext context,
      @required String chatRoomName,
      @required String chatRoomID}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkColor,
            title: Text(
              'Are you sure ? You Want To Leave $chatRoomName ?',
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
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: whiteColor,
                      fontSize: 14.0),
                ),
              ),
              MaterialButton(
                color: redColor,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(chatRoomID)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .delete()
                      .whenComplete(() {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: HomeScreen(),
                        type: PageTransitionType.rightToLeftWithFade,
                      ),
                    );
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ),
            ],
          );
        });
  }

  showLastMessage({dynamic time}) {
    Timestamp timestamp = time;
    DateTime dateTime = timestamp.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
  }

  showStickers({@required BuildContext context, @required String chatRoomId}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            height: MediaQuery.of(context).size.height * 0.5,
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
                    thickness: 4,
                    color: whiteColor,
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.1,
                //   width: MediaQuery.of(context).size.width,
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 30,
                //         width: 30,
                //         child: Image.asset('assets/icons/sunflower.png'),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(5.0),
                //           border: Border.all(color: blueColor),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rewards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                sendStickers(
                                    context: context,
                                    stickerImageUrl:
                                        documentSnapshot.data()['image'],
                                    chatRoomId: chatRoomId);
                              },
                              child: Container(
                                height: 20.0,
                                width: 20.0,
                                child: Image.network(
                                    documentSnapshot.data()['image']),
                              ),
                            );
                          }).toList(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  sendStickers({
    @required BuildContext context,
    @required String stickerImageUrl,
    @required String chatRoomId,
  }) async {
    var randomID = nanoid(5);
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'sticker': stickerImageUrl,
      'stickerID': randomID,
      'time': Timestamp.now(),
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
    });
  }

  askToJoin(
      {@required BuildContext context,
      @required String roomName,
      @required String roomId}) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: darkColor,
            title: Text(
              'Join $roomName?',
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomeScreen(),
                          type: PageTransitionType.rightToLeft));
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: whiteColor,
                      fontSize: 14.0),
                ),
              ),
              MaterialButton(
                color: greenColor,
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(roomId)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'userName':
                        Provider.of<FirebaseNotifier>(context, listen: false)
                            .getInitUserName,
                    'userImage':
                        Provider.of<FirebaseNotifier>(context, listen: false)
                            .getInitUserImage,
                    'userUid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    'time': Timestamp.now()
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              )
            ],
          );
        });
  }

  sendMessage(
      {@required BuildContext context,
      @required DocumentSnapshot documentSnapshot,
      @required TextEditingController messageController}) {
    var randomID = nanoid(5);
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(documentSnapshot.id)
        .collection('messages')
        .doc(randomID)
        .set({
      'messageID': randomID,
      'message': messageController.text,
      'messageEdited': 0,
      'time': Timestamp.now(),
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
      'messageDeleted': 0
    });
  }
}
