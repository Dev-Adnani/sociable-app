import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/AltScreenHelpers/alt.profile.helper.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/helpers/ProfileHelper/profile.helper.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nanoid/nanoid.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();

  String imageTime;
  String get getImageTime => imageTime;
  TextEditingController editCaptionController = TextEditingController();

  showTimeAgo({@required dynamic timeData}) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTime = timeago.format(dateTime);
    print('image Time => $imageTime');
  }

  showPostOptionMethod(
      {@required BuildContext context, @required String postId}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: blueColor,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: blueGreyColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 300,
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: TextField(
                                              controller: editCaptionController,
                                              decoration: InputDecoration(
                                                hintText: 'Edit your Caption',
                                                hintStyle: TextStyle(
                                                    color: whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                        FloatingActionButton(
                                          backgroundColor: redColor,
                                          child: Icon(
                                            EvaIcons.uploadOutline,
                                            color: greenColor,
                                          ),
                                          onPressed: () async {
                                            if (editCaptionController
                                                .text.isNotEmpty) {
                                              Provider.of<FirebaseNotifier>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(
                                                      postId: postId,
                                                      data: {
                                                        'caption':
                                                            editCaptionController
                                                                .text
                                                      },
                                                      userUid: Provider.of<
                                                                  Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getUserUid)
                                                  .whenComplete(() {
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              Provider.of<LandingService>(
                                                      context,
                                                      listen: false)
                                                  .warningText(
                                                      context,
                                                      'Please Type Something In Order To Edit',
                                                      16.0);
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          'Edit Caption',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      MaterialButton(
                        color: redColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: darkColor,
                                  title: Text(
                                    'Delete The Post',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    MaterialButton(
                                      color: redColor,
                                      onPressed: () {
                                        Provider.of<FirebaseNotifier>(context,
                                                listen: false)
                                            .deleteUserPost(
                                                id: postId,
                                                collection: 'posts',
                                                userUid:
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid)
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Delete Post',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future addLike(
      {@required BuildContext context,
      @required String postId,
      @required String subDocId}) async {
    var randomID = nanoid(10);
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likeId': randomID,
      'likes': FieldValue.increment(1),
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
      'userEmail': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(
      {@required BuildContext context,
      @required String postId,
      @required String comment,
      @required String commentID}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentID)
        .set({
      'commentId': commentID,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userUid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserImage,
      'userEmail': Provider.of<FirebaseNotifier>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
      'comment': comment,
    });
  }

  showCommentSheet({
    @required BuildContext context,
    @required DocumentSnapshot snapshot,
    @required String docId,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: whiteColor,
                    ),
                  ),
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      border: Border.all(color: whiteColor),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.62,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (documentSnapshot
                                                    .data()['userUid'] !=
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid) {
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    child: AltProfile(
                                                      userUid: documentSnapshot
                                                          .data()['userUid'],
                                                    ),
                                                    type: PageTransitionType
                                                        .bottomToTop),
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.0, left: 10.0),
                                            child: CircleAvatar(
                                              backgroundColor: darkColor,
                                              radius: 14,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot
                                                      .data()['userImage']),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 8.0),
                                          child: Container(
                                              child: Text(
                                            documentSnapshot.data()['userName'],
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: blueColor,
                                                size: 22,
                                              ),
                                              onPressed: () {}),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              documentSnapshot
                                                  .data()['comment'],
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserUid ==
                                                  documentSnapshot
                                                      .data()['userUid']
                                              ? IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: redColor,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                darkColor,
                                                            title: Text(
                                                              'Delete The Comment',
                                                              style: TextStyle(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            actions: [
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      color:
                                                                          whiteColor,
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              MaterialButton(
                                                                color: redColor,
                                                                onPressed: () {
                                                                  Provider.of<FirebaseNotifier>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .deleteUserComment(
                                                                    cmtId: documentSnapshot
                                                                            .data()[
                                                                        'commentId'],
                                                                    postId:
                                                                        docId,
                                                                  )
                                                                      .whenComplete(
                                                                          () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color:
                                                                          whiteColor,
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  })
                                              : Container(
                                                  width: 0,
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300.0,
                          height: 20.0,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add Comment....',
                              hintStyle: TextStyle(
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: commentController,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: greenColor,
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              print('Adding Comment');
                              var randomID = nanoid(10);

                              addComment(
                                commentID: randomID,
                                context: context,
                                postId: snapshot.data()['postId'],
                                comment: commentController.text,
                              ).whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                                Provider.of<LandingService>(context,
                                        listen: false)
                                    .warningText(context,
                                        'Comment Added Successfully', 16.0);
                              });
                            } else {
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .warningText(
                                      context,
                                      'Please Type Something In Order To Comment',
                                      16.0);
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: whiteColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showLikes({
    @required BuildContext context,
    @required String postId,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
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
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: whiteColor,
                ),
              ),
              Container(
                width: 110,
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Center(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('likes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new ListView(
                        shrinkWrap: true,
                        children: snapshot.data.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                if (documentSnapshot.data()['userUid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid) {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                          userUid: documentSnapshot
                                              .data()['userUid'],
                                        ),
                                        type: PageTransitionType.bottomToTop),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: darkColor,
                                backgroundImage: NetworkImage(
                                  documentSnapshot.data()['userImage'],
                                ),
                              ),
                            ),
                            title: Text(
                              documentSnapshot.data()['userName'],
                              style: TextStyle(
                                color: redColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot.data()['userUid']
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : MaterialButton(
                                    color: blueColor,
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      Provider.of<FirebaseNotifier>(context,
                                              listen: false)
                                          .followUser(
                                              followingUid: documentSnapshot
                                                  .data()['userUid'],
                                              followingDocId:
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid,
                                              followingData: {
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
                                                'userUid':
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid,
                                                'userEmail': Provider.of<
                                                            FirebaseNotifier>(
                                                        context,
                                                        listen: false)
                                                    .getInitUserEmail,
                                                'time': Timestamp.now(),
                                              },
                                              followerUid:
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid,
                                              followerDocId: documentSnapshot
                                                  .data()['userUid'],
                                              followerData: {
                                                'userName': documentSnapshot
                                                    .data()['userName'],
                                                'userImage': documentSnapshot
                                                    .data()['userImage'],
                                                'userEmail': documentSnapshot
                                                    .data()['userEmail'],
                                                'userUid': documentSnapshot
                                                    .data()['userUid'],
                                                'time': Timestamp.now(),
                                              })
                                          .whenComplete(() {
                                        Provider.of<AltProfileHelper>(context,
                                                listen: false)
                                            .followNotification(
                                                context: context,
                                                data: 'Followed ',
                                                name: documentSnapshot
                                                    .data()['userName']);
                                      });
                                    },
                                  ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showAwardsPresenter(
      {@required BuildContext context, @required String postId}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
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
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      'Award Tower',
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('awards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    if (documentSnapshot.data()['userUid'] !=
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid: documentSnapshot
                                                  .data()['userUid'],
                                            ),
                                            type:
                                                PageTransitionType.bottomToTop),
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: darkColor,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot.data()['userImage']),
                                  ),
                                ),
                                title: Text(
                                  documentSnapshot.data()['userName'],
                                  style: TextStyle(
                                      color: redColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot.data()['userUid']
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : MaterialButton(
                                        color: blueColor,
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          Provider.of<FirebaseNotifier>(context,
                                                  listen: false)
                                              .followUser(
                                                  followingUid: documentSnapshot
                                                      .data()['userUid'],
                                                  followingDocId: Provider.of<
                                                              Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid,
                                                  followingData: {
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
                                                    'userUid': Provider.of<
                                                                Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid,
                                                    'userEmail': Provider.of<
                                                                FirebaseNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getInitUserEmail,
                                                    'time': Timestamp.now(),
                                                  },
                                                  followerUid: Provider.of<
                                                              Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid,
                                                  followerDocId:
                                                      documentSnapshot
                                                          .data()['userUid'],
                                                  followerData: {
                                                    'userName': documentSnapshot
                                                        .data()['userName'],
                                                    'userImage':
                                                        documentSnapshot.data()[
                                                            'userImage'],
                                                    'userEmail':
                                                        documentSnapshot.data()[
                                                            'userEmail'],
                                                    'userUid': documentSnapshot
                                                        .data()['userUid'],
                                                    'time': Timestamp.now(),
                                                  })
                                              .whenComplete(() {
                                            Provider.of<AltProfileHelper>(
                                                    context,
                                                    listen: false)
                                                .followNotification(
                                                    context: context,
                                                    data: 'Followed ',
                                                    name: documentSnapshot
                                                        .data()['userName']);
                                          });
                                        },
                                      ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )),
              ],
            ),
          );
        });
  }

  showRewards({@required BuildContext context, @required String postId}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
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
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Center(
                    child: Text(
                      'Awards',
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rewards')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                  onTap: () async {
                                    await Provider.of<FirebaseNotifier>(context,
                                            listen: false)
                                        .addAward(postId: postId, data: {
                                      'userName': Provider.of<FirebaseNotifier>(
                                              context,
                                              listen: false)
                                          .getInitUserName,
                                      'userUid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserUid,
                                      'userImage':
                                          Provider.of<FirebaseNotifier>(context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'time': Timestamp.now(),
                                      'award': documentSnapshot.data()['image']
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.network(
                                          documentSnapshot.data()['image']),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }
}
