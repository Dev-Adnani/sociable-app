import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.utlis.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';

class FirebaseNotifier with ChangeNotifier {
  UploadTask imageUploadTask;
  String initUserEmail;
  String initUserName;
  String initUserImage;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;
  String get getInitUserImage => initUserImage;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() => {print('Image Uploaded')});
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'The User Profile Avatar URL => ${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching Data');
      initUserName = doc.data()['userName'];
      initUserEmail = doc.data()['userEmail'];
      initUserImage = doc.data()['userImage'];
      print('User Name => $initUserName');
      print('User Email => $initUserEmail');
      print('User Image => $initUserImage');
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }
}
