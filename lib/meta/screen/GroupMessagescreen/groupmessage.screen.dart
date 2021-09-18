import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/GroupmessageHelper/group.message.helper.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';

class GroupMessage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final TextEditingController messageController = TextEditingController();
  GroupMessage({Key key, @required this.documentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.logOutOutline,
              color: redColor,
            ),
          ),
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  documentSnapshot.data()['userUid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: whiteColor,
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
                    NetworkImage(documentSnapshot.data()['roomAvatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentSnapshot.data()['roomName'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '2 Members',
                      style: TextStyle(
                        color: greenColor.withOpacity(0.5),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
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
                        documentSnapshots: documentSnapshot,
                        adminUserUid: documentSnapshot.data()['userUid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
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
                                      documentSnapshot: documentSnapshot,
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
