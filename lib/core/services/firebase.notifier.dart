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

  Future uploadPostData(
      {@required String postId, @required dynamic data}) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future addAward({@required String postId, @required dynamic data}) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future deleteUserPost(
      {@required String id, @required dynamic collection}) async {
    return FirebaseFirestore.instance.collection(collection).doc(id).delete();
  }

  Future updateCaption({@required String postId, @required dynamic data}) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      {@required String followingUid,
      @required String followingDocId,
      @required dynamic followingData,
      @required String followerUid,
      @required String followerDocId,
      @required dynamic followerData}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}
