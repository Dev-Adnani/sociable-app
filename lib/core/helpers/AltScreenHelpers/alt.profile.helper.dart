import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';
import 'package:social_tower/core/utils/posts.functions.dart';

class AltProfileHelper with ChangeNotifier {
  Widget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: whiteColor,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageTransition(
                child: HomeScreen(), type: PageTransitionType.bottomToTop),
          );
        },
      ),
      title: RichText(
        text: TextSpan(
            text: 'S',
            style: TextStyle(
              color: greenColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: [
              TextSpan(
                text: 'oc',
                style: TextStyle(
                    color: yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              TextSpan(
                text: 'ia',
                style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              TextSpan(
                text: 'ble',
                style: TextStyle(
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ]),
      ),
      backgroundColor: blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: whiteColor,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget headerProfile(
      {@required BuildContext context,
      @required AsyncSnapshot<DocumentSnapshot> snapshot,
      @required String userUid}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 220.0,
                width: 170.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircleAvatar(
                          backgroundColor: transperant,
                          radius: 60.0,
                          backgroundImage:
                              NetworkImage(snapshot.data.data()['userImage']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data.data()['userName'],
                        style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            checkFollowersSheet(
                                context: context, snapshot: snapshot);
                          },
                          child: Container(
                            height: 70.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data.data()['userUid'])
                                      .collection('followers')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return new Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Hell');
                            checkFollowingSheet(
                                context: context, snapshot: snapshot);
                          },
                          child: Container(
                            height: 70.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data.data()['userUid'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return new Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 70.0,
                      width: 80.0,
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(snapshot.data.data()['userUid'])
                                .collection('posts')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return new Text(
                                  snapshot.data.docs.length.toString(),
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                );
                              }
                            },
                          ),
                          Text(
                            'Posts',
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    Provider.of<FirebaseNotifier>(context, listen: false)
                        .followUser(
                            followingUid: userUid,
                            followingDocId: Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            followingData: {
                              'userName': Provider.of<FirebaseNotifier>(context,
                                      listen: false)
                                  .getInitUserName,
                              'userImage': Provider.of<FirebaseNotifier>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'userUid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'userEmail': Provider.of<FirebaseNotifier>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'time': Timestamp.now(),
                            },
                            followerUid: Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            followerDocId: userUid,
                            followerData: {
                              'userName': snapshot.data.data()['userName'],
                              'userImage': snapshot.data.data()['userImage'],
                              'userEmail': snapshot.data.data()['userEmail'],
                              'userUid': snapshot.data.data()['userUid'],
                              'time': Timestamp.now(),
                            })
                        .whenComplete(() {
                      followNotification(
                          context: context,
                          data: 'Followed ',
                          name: snapshot.data.data()['userName']);
                    });
                  },
                  color: blueColor,
                  child: Text(
                    'Follow',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Provider.of<FirebaseNotifier>(context, listen: false)
                        .unFollowUser(
                            followingUid: userUid,
                            followingDocId: Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            followingData: {
                              'userName': Provider.of<FirebaseNotifier>(context,
                                      listen: false)
                                  .getInitUserName,
                              'userImage': Provider.of<FirebaseNotifier>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'userUid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'userEmail': Provider.of<FirebaseNotifier>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'time': Timestamp.now(),
                            },
                            followerUid: Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            followerDocId: userUid,
                            followerData: {
                              'userName': snapshot.data.data()['userName'],
                              'userImage': snapshot.data.data()['userImage'],
                              'userEmail': snapshot.data.data()['userEmail'],
                              'userUid': snapshot.data.data()['userUid'],
                              'time': Timestamp.now(),
                            })
                        .whenComplete(() {
                      followNotification(
                          context: context,
                          data: 'Unfollowed ',
                          name: snapshot.data.data()['userName']);
                    });
                  },
                  color: blueColor,
                  child: Text(
                    'Unfollow',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget status({BuildContext context, String userUid}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, left: 40.0, right: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUid)
                  .collection('status')
                  .doc('st')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState ==
                        ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: Text(
                      snapshot.data.data() == null
                          ? 'Hey there I am on Sociable'
                          : snapshot.data.data()['userBio'],
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350,
        child: Divider(
          color: whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(
      {@required BuildContext context,
      @required AsyncSnapshot<DocumentSnapshot> snapshot}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      FontAwesomeIcons.userAstronaut,
                      color: yellowColor,
                      size: 16,
                    ),
                    Text(
                      'Recently Added',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: whiteColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(snapshot.data.data()['userUid'])
                        .collection('following')
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  height: 60.0,
                                  width: 60.0,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          documentSnapshot.data()['userImage']),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        );
                      }
                    },
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: darkColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(
      {@required BuildContext context,
      @required AsyncSnapshot<DocumentSnapshot> snapshot}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data['userUid'])
                .collection('posts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return new GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot snapshot) {
                      return GestureDetector(
                        onTap: () {
                          showPostDetails(
                              context: context, documentSnapshot: snapshot);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .8,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: Image.network(snapshot['postImage']),
                          ),
                        ),
                      );
                    }).toList());
              }
            },
          ),
        ),
      ),
    );
  }

  followNotification({BuildContext context, String name, String data}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: whiteColor,
                    ),
                  ),
                  Text(
                    '$data $name',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  )
                ],
              ),
            ),
          );
        });
  }

  checkFollowersSheet({BuildContext context, dynamic snapshot}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data.data()['userUid'])
                  .collection('followers')
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          onTap: () {
                            if (documentSnapshot.data()['userUid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid:
                                          documentSnapshot.data()['userUid'],
                                    ),
                                    type: PageTransitionType.rightToLeft),
                              );
                            }
                          },
                          trailing: documentSnapshot.data()['userUid'] ==
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : MaterialButton(
                                  color: greyColor,
                                  child: Text(
                                    'Unfollow',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  onPressed: () {},
                                ),
                          leading: CircleAvatar(
                            backgroundColor: darkColor,
                            backgroundImage: NetworkImage(
                                documentSnapshot.data()['userImage']),
                          ),
                          title: Text(
                            documentSnapshot.data()['userName'],
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }

  checkFollowingSheet({BuildContext context, dynamic snapshot}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data.data()['userUid'])
                  .collection('following')
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          leading: CircleAvatar(
                            backgroundColor: darkColor,
                            backgroundImage: NetworkImage(
                                documentSnapshot.data()['userImage']),
                          ),
                          title: Text(
                            documentSnapshot.data()['userName'],
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }

  showPostDetails({BuildContext context, DocumentSnapshot documentSnapshot}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.63,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child:
                          Image.network(documentSnapshot.data()['postImage']),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  documentSnapshot.data()['caption'],
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 72.0),
                        child: Container(
                          height: 40,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showLikes(
                                          context: context,
                                          postId: documentSnapshot
                                              .data()['postId']);
                                },
                                onTap: () {
                                  print('Added Like');
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .addLike(
                                          context: context,
                                          postId:
                                              documentSnapshot.data()['postId'],
                                          subDocId: Provider.of<Authentication>(
                                                  context,
                                                  listen: false)
                                              .getUserUid);
                                },
                                child: Icon(
                                  FontAwesomeIcons.heart,
                                  color: redColor,
                                  size: 22,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(documentSnapshot.data()['postId'])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(
                                        context: context,
                                        snapshot: documentSnapshot,
                                        docId:
                                            documentSnapshot.data()['postId']);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: yellowColor,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(documentSnapshot.data()['postId'])
                                  .collection('comments')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showAwardsPresenter(
                                          context: context,
                                          postId: documentSnapshot
                                              .data()['postId']);
                                },
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showRewards(
                                          context: context,
                                          postId: documentSnapshot
                                              .data()['postId']);
                                },
                                child: Icon(
                                  FontAwesomeIcons.award,
                                  color: greenColor,
                                  size: 22,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(documentSnapshot.data()['postId'])
                                    .collection('awards')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              documentSnapshot.data()['userUid']
                          ? IconButton(
                              icon: Icon(EvaIcons.moreVertical,
                                  color: whiteColor),
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptionMethod(
                                        context: context,
                                        postId:
                                            documentSnapshot.data()['postId']);
                              },
                            )
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
