import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/ChatroomHelper/chatroom.helper.dart';

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
            onPressed: () {},
            icon: Icon(EvaIcons.moreVertical, color: whiteColor),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Provider.of<ChatroomHelper>(context, listen: false)
                .showCreateChatroomSheet(context: context);
          },
          icon: Icon(FontAwesomeIcons.plus, color: greenColor),
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
