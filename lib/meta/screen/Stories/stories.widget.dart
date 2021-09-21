import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/StoryHelper/story.helper.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class StoryWidget {
  addStory(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: blueColor,
                        child: Text('Gallery',
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Provider.of<StoriesHelper>(context, listen: false)
                              .selectStoryImage(
                                  context: context, source: ImageSource.gallery)
                              .whenComplete(() {});
                        }),
                    MaterialButton(
                        color: blueColor,
                        child: Text('Camera',
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Provider.of<StoriesHelper>(context, listen: false)
                              .selectStoryImage(
                                  context: context, source: ImageSource.camera)
                              .whenComplete(() {
                            Navigator.pop(context);
                          });
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  previewStoryImage(
      {@required BuildContext context, @required File storyImage}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.file(storyImage),
                  ),
                ),
                Positioned(
                  top: 700,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                            heroTag: 'Reselect Image',
                            backgroundColor: redColor,
                            child: Icon(
                              FontAwesomeIcons.backward,
                              color: whiteColor,
                            ),
                            onPressed: () {
                              addStory(context);
                            }),
                        FloatingActionButton(
                            heroTag: 'Confirm Image',
                            backgroundColor: blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: whiteColor,
                            ),
                            onPressed: () {
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .uploadStoryImage(context: context)
                                  .whenComplete(() async {
                                try {
                                  if (Provider.of<StoriesHelper>(context,
                                              listen: false)
                                          .getStoryImageUrl !=
                                      null) {
                                    await FirebaseFirestore.instance
                                        .collection('stories')
                                        .doc(Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid)
                                        .set({
                                      'image': Provider.of<StoriesHelper>(
                                              context,
                                              listen: false)
                                          .getStoryImageUrl,
                                      'userName': Provider.of<FirebaseNotifier>(
                                              context,
                                              listen: false)
                                          .getInitUserName,
                                      'userImage':
                                          Provider.of<FirebaseNotifier>(context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'time': Timestamp.now(),
                                      'userUid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserUid
                                    }).whenComplete(() {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: HomeScreen(),
                                              type: PageTransitionType
                                                  .bottomToTop));
                                    });
                                  } else {
                                    return showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            decoration:
                                                BoxDecoration(color: darkColor),
                                            child: Center(
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('stories')
                                                      .doc(Provider.of<
                                                                  Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getUserUid)
                                                      .set({
                                                    'image': Provider.of<
                                                                StoriesHelper>(
                                                            context,
                                                            listen: false)
                                                        .getStoryImageUrl,
                                                    'userName': Provider.of<
                                                                FirebaseNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserName,
                                                    'userImage': Provider.of<
                                                                FirebaseNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserImage,
                                                    'time': Timestamp.now(),
                                                    'userUid': Provider.of<
                                                                Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid
                                                  }).whenComplete(() {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        PageTransition(
                                                            child: HomeScreen(),
                                                            type: PageTransitionType
                                                                .bottomToTop));
                                                  });
                                                },
                                                child: Text('Upload Story!',
                                                    style: TextStyle(
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0)),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
