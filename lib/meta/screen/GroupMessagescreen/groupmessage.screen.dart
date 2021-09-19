import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/GroupmessageHelper/group.message.helper.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage({Key key, @required this.documentSnapshot}) : super(key: key);

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoined(
            context: context,
            chatRoomName: widget.documentSnapshot.id,
            chatRoomAdminUid: widget.documentSnapshot.data()['userUid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelper>(context, listen: false)
              .getHasMemberJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessageHelper>(context, listen: false)
                .askToJoin(
                    context: context,
                    roomName: widget.documentSnapshot.data()['roomName'],
                    roomId: widget.documentSnapshot.id));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserUid !=
                  widget.documentSnapshot.data()['userUid']
              ? IconButton(
                  onPressed: () {
                    Provider.of<GroupMessageHelper>(context, listen: false)
                        .leaveTheRoom(
                            context: context,
                            chatRoomName:
                                widget.documentSnapshot.data()['roomName'],
                            chatRoomID:
                                widget.documentSnapshot.data()['roomID']);
                  },
                  icon: Icon(
                    EvaIcons.logOutOutline,
                    color: redColor,
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: whiteColor,
          ),
        ),
        backgroundColor: blueGreyColor.withOpacity(0.6),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: transperant,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot.data()['roomAvatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot.data()['roomName'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroom')
                          .doc(widget.documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new Text(
                            '${snapshot.data.docs.length.toString()} members',
                            style: TextStyle(
                              color: greenColor.withOpacity(0.5),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .showMessages(
                        context: context,
                        documentSnapshots: widget.documentSnapshot,
                        adminUserUid:
                            widget.documentSnapshot.data()['userUid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .showStickers(
                                  context: context,
                                  chatRoomId:
                                      widget.documentSnapshot.data()['roomID']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: transperant,
                            backgroundImage:
                                AssetImage('assets/images/chatbox.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                                color: greenColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: blueColor,
                          child: Icon(
                            Icons.send_sharp,
                            color: whiteColor,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              Provider.of<GroupMessageHelper>(context,
                                      listen: false)
                                  .sendMessage(
                                      context: context,
                                      documentSnapshot: widget.documentSnapshot,
                                      messageController: messageController);
                              messageController.clear();
                            } else {
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .warningText(
                                      context, 'Please Enter A Message', 16.0);
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
