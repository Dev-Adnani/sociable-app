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
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class StoryWidget {
  final TextEditingController storyHighlightTitleController =
      TextEditingController();
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

  addToHighlights({BuildContext context, String storyImage}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: whiteColor,
                    ),
                  ),
                  Text('Add To Existing Album',
                      style: TextStyle(
                          color: yellowColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('highlights')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return new ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .addStoryToExistingAlbum(
                                            context: context,
                                            userUid:
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid,
                                            highlightColId: documentSnapshot.id,
                                            storyImage: storyImage);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: darkColor,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot
                                                    .data()['cover']),
                                            radius: 20,
                                          ),
                                          Text(documentSnapshot.data()['title'],
                                              style: TextStyle(
                                                  color: greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList());
                        }
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text('Create New Album',
                      style: TextStyle(
                          color: greenColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
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
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                    onTap: () {
                                      Provider.of<StoriesHelper>(context,
                                              listen: false)
                                          .convertHighlightedIcon(
                                              documentSnapshot.data()['image']);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: Image.network(
                                            documentSnapshot.data()['image']),
                                      ),
                                    ));
                              }).toList());
                        }
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: storyHighlightTitleController,
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            decoration: InputDecoration(
                              hintText: 'Add Album Title...',
                              hintStyle: TextStyle(
                                  color: blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: blueColor,
                            child:
                                Icon(FontAwesomeIcons.check, color: whiteColor),
                            onPressed: () {
                              if (storyHighlightTitleController
                                  .text.isNotEmpty) {
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .addStoryToNewAlbum(
                                        context: context,
                                        userUid: Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid,
                                        highlightName:
                                            storyHighlightTitleController.text,
                                        storyImage: storyImage);
                              } else {
                                return showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: darkColor,
                                        height: 100.0,
                                        width: 400.0,
                                        child: Center(
                                          child: Text('Add album title'),
                                        ),
                                      );
                                    });
                              }
                            })
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: darkColor, borderRadius: BorderRadius.circular(12.0)),
            ),
          );
        });
  }

  showViewers(BuildContext context, String storyId, String personUid) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4.0,
                  color: whiteColor,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .doc(storyId)
                        .collection('seen')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Provider.of<StoriesHelper>(context, listen: false)
                                .storyTimePosted(
                                    documentSnapshot.data()['time']);
                            return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userImage']),
                                  backgroundColor: darkColor,
                                  radius: 25.0,
                                ),
                                trailing: documentSnapshot.data()['userUid'] !=
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid
                                    ? IconButton(
                                        icon: Icon(
                                            FontAwesomeIcons.arrowCircleRight,
                                            color: yellowColor),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: AltProfile(
                                                      userUid: documentSnapshot
                                                          .data()['userUid']),
                                                  type: PageTransitionType
                                                      .bottomToTop));
                                        },
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                title: Text(documentSnapshot.data()['userName'],
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)),
                                subtitle: Text(
                                    Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .getLastSeenTime
                                        .toString(),
                                    style: TextStyle(
                                        color: greenColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0)));
                          }).toList(),
                        );
                      }
                    },
                  ))
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: darkColor, borderRadius: BorderRadius.circular(12.0)),
        );
      },
    );
  }

  previewAllHighlights(BuildContext context, String hightlightTitle) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('highlights')
                .doc(hightlightTitle)
                .collection('stories')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PageView(
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                  return Container(
                    decoration: BoxDecoration(color: darkColor),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(documentSnapshot.data()['image']),
                  );
                }).toList());
              }
            },
          ),
        );
      },
    );
  }
}
