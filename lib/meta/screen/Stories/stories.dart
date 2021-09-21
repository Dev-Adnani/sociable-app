import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/StoryHelper/story.helper.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';
import 'package:social_tower/meta/screen/Stories/stories.widget.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final StoryWidget storyWidget = new StoryWidget();
  Stories({Key key, @required this.documentSnapshot}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  void initState() {
    Provider.of<StoriesHelper>(context, listen: false)
        .storyTimePosted(widget.documentSnapshot.data()['time']);
    Provider.of<StoriesHelper>(context, listen: false).addSeenStamp(
        context: context,
        documentSnapshot: widget.documentSnapshot,
        personId:
            Provider.of<Authentication>(context, listen: false).getUserUid,
        storyId: widget.documentSnapshot.id);
    Timer(
      Duration(seconds: 15),
      () => Navigator.push(
        context,
        PageTransition(
            child: HomeScreen(), type: PageTransitionType.bottomToTop),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            Navigator.push(
              context,
              PageTransition(
                  child: HomeScreen(), type: PageTransitionType.bottomToTop),
            );
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.documentSnapshot.data()['image'],
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: darkColor,
                        radius: 25,
                        backgroundImage: NetworkImage(
                            widget.documentSnapshot.data()['userImage']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.documentSnapshot.data()['userName'],
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .getStoryTime,
                              style: TextStyle(
                                color: greyColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Provider.of<Authentication>(context, listen: false)
                                .getUserUid ==
                            widget.documentSnapshot.data()['userUid']
                        ? GestureDetector(
                            onTap: () {
                              widget.storyWidget.showViewers(
                                context,
                                widget.documentSnapshot.id,
                                widget.documentSnapshot.data()['userUid'],
                              );
                            },
                            child: Container(
                              height: 30.0,
                              width: 50.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidEye,
                                    color: yellowColor,
                                    size: 16,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('stories')
                                          .doc(widget.documentSnapshot.id)
                                          .collection('seen')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularCountDownTimer(
                        isTimerTextShown: false,
                        duration: 15,
                        fillColor: blueColor,
                        width: 20.0,
                        height: 20.0,
                        ringColor: darkColor,
                      ),
                    ),
                    Provider.of<Authentication>(context, listen: false)
                                .getUserUid ==
                            widget.documentSnapshot.data()['userUid']
                        ? IconButton(
                            onPressed: () {
                              return showMenu(
                                  color: darkColor,
                                  context: context,
                                  position:
                                      RelativeRect.fromLTRB(300.0, 70.0, 0, 0),
                                  items: [
                                    PopupMenuItem(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          widget.storyWidget.addToHighlights(
                                              context: context,
                                              storyImage: widget
                                                  .documentSnapshot
                                                  .data()['image']);
                                        },
                                        label: Text(
                                          'Add To Highlights',
                                          style: TextStyle(
                                            color: whiteColor,
                                          ),
                                        ),
                                        icon: Icon(
                                          FontAwesomeIcons.archive,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('stories')
                                              .doc(widget.documentSnapshot.id)
                                              .delete()
                                              .whenComplete(() {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: HomeScreen(),
                                                  type: PageTransitionType
                                                      .bottomToTop),
                                            );
                                          });
                                        },
                                        label: Text(
                                          'Delete Story',
                                          style: TextStyle(
                                            color: whiteColor,
                                          ),
                                        ),
                                        icon: Icon(
                                          FontAwesomeIcons.trash,
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  ]);
                            },
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: whiteColor,
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
