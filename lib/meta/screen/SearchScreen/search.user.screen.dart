import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/AltProfileScreen/alt.profile.screen.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class SearchUser extends StatefulWidget {
  SearchUser({Key key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController searchUserController = TextEditingController();
  QuerySnapshot snapshot;
  bool isExecuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.6),
        actions: [
          IconButton(
            onPressed: () {
              if (searchUserController.text.isNotEmpty) {
                print('=> 1 - ${searchUserController.text}');
                searchData(searchUserController.text);
                setState(() {
                  isExecuted = true;
                });
              }
            },
            icon: Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: HomeScreen(), type: PageTransitionType.rightToLeft));
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: greenColor,
          ),
        ),
        title: TextField(
          controller: searchUserController,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Search Any User',
            hintStyle: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: isExecuted
          ? searchData(searchUserController.text)
          : Container(
              child: Center(
                child: Text(
                  'Search Any User',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        child: Icon(Icons.clear),
        onPressed: () {
          searchUserController.clear();
          setState(() {
            isExecuted = false;
          });
        },
      ),
    );
  }

  Widget searchData(String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: query)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
              children: snapshot.data.docs.map(
            (DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  if (documentSnapshot.data()['userUid'] !=
                      Provider.of<Authentication>(context, listen: false)
                          .getUserUid) {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AltProfile(
                                userUid: documentSnapshot.data()['userUid']),
                            type: PageTransitionType.rightToLeft));
                  }
                },
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(documentSnapshot.data()['userImage']),
                ),
                title: Text(
                  documentSnapshot.data()['userName'],
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  documentSnapshot.data()['userEmail'],
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ).toList());
        }
      },
    );
  }
}
