import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/meta/screen/Stories/stories.widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHelper with ChangeNotifier {
  final picker = ImagePicker();
  File storyImage;
  UploadTask imageUploadTask;
  final StoryWidget storyWidget = StoryWidget();
  String storyImageUrl;
  String storyHighlightIcon;
  String storyTime;
  String lastSeenTime;
  String get getLastSeenTime => lastSeenTime;
  String get getStoryImageUrl => storyImageUrl;
  File get getStoryImage => storyImage;
  String get getStoryTime => storyTime;
  String get getStoryHighlightIcon => storyHighlightIcon;

  Future selectStoryImage({BuildContext context, ImageSource source}) async {
    final pickedImage = await picker.getImage(source: source, imageQuality: 50);
    pickedImage == null ? print('Error') : storyImage = File(pickedImage.path);
    storyImage != null
        ? storyWidget.previewStoryImage(
            context: context, storyImage: storyImage)
        : print('Error');
    notifyListeners();
  }

  Future uploadStoryImage({BuildContext context}) async {
    Reference imageRef = FirebaseStorage.instance.ref().child(
        'stories/${Provider.of<Authentication>(context, listen: false).getUserUid}/${Timestamp.now()}}');
    imageUploadTask = imageRef.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {
      print('Donee');
    });
    imageRef.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    print(storyHighlightIcon);
    notifyListeners();
  }

  Future addStoryToExistingAlbum(
      {BuildContext context,
      String userUid,
      String highlightColId,
      String storyImage}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightColId)
        .collection('stories')
        .add({
      'image': storyImage,
      'userName':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserName,
      'userImage':
          Provider.of<FirebaseNotifier>(context, listen: false).getInitUserImage
    });
  }

  Future addStoryToNewAlbum(
      {BuildContext context,
      String userUid,
      String highlightName,
      String storyImage}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': getStoryImageUrl,
        'userName': Provider.of<FirebaseNotifier>(context, listen: false)
            .getInitUserName,
        'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
            .getInitUserImage
      });
    });
  }

  storyTimePosted(dynamic timeData) {
    Timestamp timestamp = timeData;
    DateTime dateTime = timestamp.toDate();
    storyTime = timeago.format(dateTime);
    lastSeenTime = timeago.format(dateTime);
    notifyListeners();
  }

  Future addSeenStamp(
      {BuildContext context,
      String storyId,
      String personId,
      DocumentSnapshot documentSnapshot}) async {
    if (documentSnapshot.data()['useruid'] !=
        Provider.of<Authentication>(context, listen: false).getUserUid) {
      return FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('seen')
          .doc(personId)
          .set({
        'time': Timestamp.now(),
        'userName': Provider.of<FirebaseNotifier>(context, listen: false)
            .getInitUserName,
        'userImage': Provider.of<FirebaseNotifier>(context, listen: false)
            .getInitUserImage,
        'userUid':
            Provider.of<Authentication>(context, listen: false).getUserUid
      });
    }
  }
}
