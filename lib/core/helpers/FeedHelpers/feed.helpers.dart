import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/utils/posts.functions.dart';
import 'package:social_tower/core/utils/upload.post.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';

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
        )
      ],
      title: RichText(
        text: TextSpan(
            text: 'Tower ',
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

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: darkColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: 400.0,
                    child: Lottie.asset('assets/animations/loading.json'),
                  ),
                );
              } else {
                return loadPost(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
                                documentSnapshot.data()['caption'],
                                style: TextStyle(
                                    color: greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                            Container(
                                child: RichText(
                              text: TextSpan(
                                text: documentSnapshot.data()['userName'],
                                style: TextStyle(
                                  color: blueColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' , 12 hours ago',
                                    style: TextStyle(
                                      color: lightColor.withOpacity(0.8),
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.46,
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
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
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
                                            documentSnapshot.data()['caption']);
                              },
                              onTap: () {
                                print('Added Like');
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .addLike(
                                        context: context,
                                        postId:
                                            documentSnapshot.data()['caption'],
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
                                  .doc(documentSnapshot.data()['caption'])
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
                                            documentSnapshot.data()['caption']);
                              },
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: yellowColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              onTap: () {},
                              child: Icon(
                                FontAwesomeIcons.award,
                                color: greenColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              onPressed: () {},
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
