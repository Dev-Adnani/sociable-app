import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/utils/posts.functions.dart';
import 'package:social_tower/core/utils/upload.post.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/Profilescreen/profile.screen.dart';
import 'package:social_tower/meta/screen/Stories/stories.dart';

class FeedHelpers with ChangeNotifier {
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .selectPostImageType(context);
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: greenColor,
          ),
        ),
      ],
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(FontAwesomeIcons.userAlt),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    child: ProfileScreen(),
                    type: PageTransitionType.rightToLeft),
              );
            },
          )),
      title: RichText(
        text: TextSpan(
            text: 'Sociable ',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: [
              TextSpan(
                text: 'Feed',
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            ]),
      ),
    );
  }

  Widget feedStories({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('stories').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                scrollDirection: Axis.horizontal,
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: Stories(
                                documentSnapshot: documentSnapshot,
                              ),
                              type: PageTransitionType.bottomToTop),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                documentSnapshot.data()['userImage']),
                          ),
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: blueColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ));
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                        height: 500.0,
                        width: 400.0,
                        child: Lottie.asset('assets/animations/loading.json')),
                  );
                } else {
                  return loadPost(context, snapshot);
                }
              },
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: darkColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0))),
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
        Provider.of<PostFunctions>(context, listen: false)
            .showTimeAgo(timeData: documentSnapshot.data()['time']);
        return Container(
          height: MediaQuery.of(context).size.height * 0.68,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      child: GestureDetector(
                        onTap: () {
                          if (documentSnapshot.data()['userUid'] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid) {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: documentSnapshot.data()['userUid'],
                                  ),
                                  type: PageTransitionType.bottomToTop),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                              documentSnapshot.data()['userImage']),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                documentSnapshot.data()['userName'],
                                style: TextStyle(
                                    color: greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Container(
                              child: RichText(
                                  text: TextSpan(
                                text:
                                    '${Provider.of<PostFunctions>(context, listen: false).getImageTime.toString()}',
                                style: TextStyle(
                                  color: lightColor.withOpacity(0.8),
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * .2,
                      child: StreamBuilder<QuerySnapshot>(
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
                              return new ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot documentSnapshot) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 50.0,
                                      height: 30.0,
                                      child: Image.network(
                                          documentSnapshot.data()['award']),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(
                      documentSnapshot.data()['postImage'],
                      scale: 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            documentSnapshot.data()['caption'],
                            style: TextStyle(
                              color: greyColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
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
                                        postId:
                                            documentSnapshot.data()['postId']);
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
                                    padding: const EdgeInsets.only(left: 10.0),
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
                        child: Row(
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showAwardsPresenter(
                                        context: context,
                                        postId:
                                            documentSnapshot.data()['postId']);
                              },
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showRewards(
                                        context: context,
                                        postId:
                                            documentSnapshot.data()['postId']);
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
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
