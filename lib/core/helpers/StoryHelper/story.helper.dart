import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/meta/screen/Stories/stories.widget.dart';

class StoriesHelper with ChangeNotifier {
  final picker = ImagePicker();
  File storyImage;
  UploadTask imageUploadTask;
  File get getStoryImage => storyImage;
  final StoryWidget storyWidget = StoryWidget();
  String storyImageUrl;
  String get getStoryImageUrl => storyImageUrl;

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
}
