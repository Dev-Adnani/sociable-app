import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();

  Future addLike(
      {@required BuildContext context,
      @required String postId,
      @required String subDocId}) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
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
      @required String comment}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
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

  showCommentSheet(
      {@required BuildContext context,
      @required DocumentSnapshot snapshot,
      @required String docId}) {
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
                                    MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: darkColor,
                                            radius: 15,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot
                                                    .data()['userImage']),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    documentSnapshot
                                                        .data()['userName'],
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.arrowUp,
                                                    color: blueColor,
                                                  ),
                                                  onPressed: () {}),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: yellowColor,
                                                  ),
                                                  onPressed: () {}),
                                              IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: redColor,
                                                  ),
                                                  onPressed: () {}),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: blueColor,
                                                size: 12,
                                              ),
                                              onPressed: () {}),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              documentSnapshot
                                                  .data()['comment'],
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: darkColor.withOpacity(0.2),
                                    )
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
                            print('Adding Comment');
                            addComment(
                                context: context,
                                postId: snapshot.data()['caption'],
                                comment: commentController.text);
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

  showLikes({@required BuildContext context, @required String postId}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.50,
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
                            subtitle: Text(
                              documentSnapshot.data()['userEmail'],
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            trailing: MaterialButton(
                              color: blueColor,
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onPressed: () {},
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
}
