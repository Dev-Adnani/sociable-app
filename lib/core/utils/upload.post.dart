import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landingService.notifier.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:nanoid/nanoid.dart';

class UploadPost with ChangeNotifier {
  File uploastPostImage;
  File get getUploadPostImage => uploastPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask;
  TextEditingController captionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal =
        await picker.getImage(source: source, imageQuality: 40);
    uploadPostImageVal == null
        ? print('Select Image')
        : uploastPostImage = File(uploadPostImageVal.path);

    uploastPostImage != null ? showPostImage(context) : print('Error');
    notifyListeners();
  }

  Future uploadPostImageToFirebase(BuildContext context) async {
    Reference imgReference = FirebaseStorage.instance.ref().child(
        'posts/${Provider.of<Authentication>(context, listen: false).getUserUid}/${TimeOfDay.now()}');

    imagePostUploadTask = imgReference.putFile(uploastPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('Image Uploaded To DB');
    });

    imgReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: blueColor,
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: redColor,
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(12.0),
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                      height: 200,
                      width: 400,
                      child: uploastPostImage != null
                          ? Image.file(
                              uploastPostImage,
                              fit: BoxFit.contain,
                            )
                          : AssetImage('assets/images/empty.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          selectPostImageType(context);
                        },
                        child: Text(
                          'Reselect Image',
                          style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: whiteColor),
                        ),
                      ),
                      MaterialButton(
                        color: blueColor,
                        onPressed: () {
                          uploadPostImageToFirebase(context).whenComplete(() {
                            editPostSheet(context);
                            print('Image Uploaded');
                          });
                        },
                        child: Text(
                          'Confirm Image',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 200.0,
                          width: 300.0,
                          child: Image.file(
                            uploastPostImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Icon(
                          EvaIcons.messageCircle,
                          color: whiteColor,
                        ),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120.0,
                          width: 330.0,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLength: 100,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: captionController,
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            decoration: InputDecoration(
                              hintText: 'Caption Here',
                              hintStyle: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  color: blueColor,
                  onPressed: () async {
                    var randomID = nanoid(10);
                    if (captionController.text.isNotEmpty) {
                      print('Collection Created : Data Uploaded');
                      Provider.of<FirebaseNotifier>(context, listen: false)
                          .uploadPostData(postId: randomID, data: {
                        'postId': randomID,
                        'postImage': getUploadPostImageUrl,
                        'caption': captionController.text,
                        'userName': Provider.of<FirebaseNotifier>(context,
                                listen: false)
                            .getInitUserName,
                        'userImage': Provider.of<FirebaseNotifier>(context,
                                listen: false)
                            .getInitUserImage,
                        'userUid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'userEmail': Provider.of<FirebaseNotifier>(context,
                                listen: false)
                            .getInitUserEmail,
                      }).whenComplete(() async {
                        // Add Data User To User Profile
                        return FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid)
                            .collection('posts')
                            .doc(randomID)
                            .set({
                          'postId': randomID,
                          'postImage': getUploadPostImageUrl,
                          'caption': captionController.text,
                          'userName': Provider.of<FirebaseNotifier>(context,
                                  listen: false)
                              .getInitUserName,
                          'userImage': Provider.of<FirebaseNotifier>(context,
                                  listen: false)
                              .getInitUserImage,
                          'userUid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'time': Timestamp.now(),
                          'userEmail': Provider.of<FirebaseNotifier>(context,
                                  listen: false)
                              .getInitUserEmail,
                        });
                      }).whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    } else {
                      Provider.of<LandingService>(context, listen: false)
                          .warningText(context,
                              'Please Type Something In Order To Post', 20.0);
                    }
                  },
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                )
              ],
            ),
          );
        });
  }
}
