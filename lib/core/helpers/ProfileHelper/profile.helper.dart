import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/core/utils/posts.functions.dart';
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/Landingscreen/landing.screen.dart';

class ProfileHelpers with ChangeNotifier {
  TextEditingController editBioController = TextEditingController();

  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 240.0,
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
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget status({BuildContext context}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, left: 40.0, right: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
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
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
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
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextField(
                                      controller: editBioController,
                                      maxLines: 2,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      maxLength: 50,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      decoration: InputDecoration(
                                        hintText: 'Edit your Bio',
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: FloatingActionButton(
                                    backgroundColor: redColor,
                                    child: Icon(
                                      EvaIcons.uploadOutline,
                                      color: greenColor,
                                    ),
                                    onPressed: () async {
                                      if (editBioController.text.isNotEmpty) {
                                        Provider.of<FirebaseNotifier>(context,
                                                listen: false)
                                            .addBio(
                                                userUid:
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid,
                                                data: {
                                              'userBio': editBioController.text
                                            })
                                          ..whenComplete(() {
                                            editBioController.clear();
                                            Navigator.pop(context);
                                          });
                                      } else {
                                        Provider.of<LandingService>(context,
                                                listen: false)
                                            .warningText(
                                                context,
                                                'Please Type Something In Order To Edit',
                                                16.0);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Icon(
                EvaIcons.edit,
                color: greenColor,
                size: 16,
              ),
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
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                                      onTap: () {
                                        if (documentSnapshot
                                                .data()['userUid'] !=
                                            Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid) {
                                          Navigator.push(
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
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            documentSnapshot
                                                .data()['userImage']),
                                      )),
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
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(
                    Provider.of<Authentication>(context, listen: false).userUid)
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
                  children: snapshot.data.docs.map((DocumentSnapshot snapshot) {
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
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  logoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkColor,
            title: Text(
              'Are you Sure You Want To Logout ?',
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
                      color: whiteColor,
                      decoration: TextDecoration.underline,
                      decorationColor: whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                color: redColor,
                onPressed: () {
                  Provider.of<Authentication>(context, listen: false)
                      .logout()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: LandingPage(),
                            type: PageTransitionType.rightToLeft));
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
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
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid:
                                          documentSnapshot.data()['userUid'],
                                    ),
                                    type: PageTransitionType.rightToLeft));
                          },
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
                          leading: CircleAvatar(
                            backgroundColor: darkColor,
                            backgroundImage: NetworkImage(
                                documentSnapshot.data()['userImage']),
                          ),
                          title: Text(
                            documentSnapshot.data()['userName'],
                            style: TextStyle(
                                color: greenColor,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 64.0),
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
                            )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
