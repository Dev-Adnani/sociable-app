import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/ChatroomHelper/chatroom.helper.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColor.withOpacity(0.6),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ChatroomHelper>(context, listen: false)
                  .showCreateChatroomSheet(context: context);
            },
            icon: Icon(FontAwesomeIcons.plus, color: greenColor),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                  child: HomeScreen(), type: PageTransitionType.rightToLeft),
            );
          },
          icon: Icon(Icons.arrow_back_ios_outlined, color: greenColor),
        ),
        title: RichText(
          text: TextSpan(
              text: 'Chat ',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: [
                TextSpan(
                  text: 'Box',
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                )
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueGreyColor,
        child: Icon(FontAwesomeIcons.plus, color: greenColor),
        onPressed: () {
          Provider.of<ChatroomHelper>(context, listen: false)
              .showCreateChatroomSheet(context: context);
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Provider.of<ChatroomHelper>(context, listen: false)
            .showChatrooms(context: context),
      ),
    );
  }
}
