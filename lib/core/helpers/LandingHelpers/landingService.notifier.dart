import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/app/constants/constant.colors.dart';
import 'package:social_tower/core/helpers/LandingHelpers/landing.utlis.dart';
import 'package:social_tower/core/services/authentication.notifier.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';
import 'package:social_tower/meta/screen/Homescreen/home.screen.dart';

class LandingService with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNumberController = TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      Provider.of<LandingUtils>(context, listen: true)
                                  .userAvatar !=
                              null
                          ? FileImage(
                              Provider.of<LandingUtils>(context, listen: true)
                                  .userAvatar)
                          : AssetImage('assets/images/empty.png')
                              as ImageProvider<Object>,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery);
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
                          if (Provider.of<LandingUtils>(context, listen: false)
                                  .userAvatar ==
                              null) {
                            warningText(context, 'Please Select A Image', 16.0);
                          } else {
                            Provider.of<FirebaseNotifier>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() {
                              signInSheet(context);
                            });
                          }
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
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return new ListView(
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.trashAlt,
                        color: redColor,
                      )),
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        (documentSnapshot.data() as dynamic)['userImage']),
                  ),
                  title: Text(
                    (documentSnapshot.data() as dynamic)['userName'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: greenColor),
                  ),
                  subtitle: Text(
                    (documentSnapshot.data() as dynamic)['userEmail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: greenColor,
                        fontSize: 12.0),
                  ),
                );
              }).toList());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.horizontal * 0.2),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: blueColor,
                      onPressed: () {
                        if (userEmailController.text.isNotEmpty &&
                            userPasswordController.text.isNotEmpty) {
                          if (RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(userEmailController.text) &&
                              userPasswordController.text.length > 6) {
                            Provider.of<Authentication>(context, listen: false)
                                .logIntoAccount(
                                    email: userEmailController.text,
                                    password: userPasswordController.text,
                                    context: context)
                                .then((value) {
                              if (value) {
                                if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .isVerified) {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: HomeScreen(),
                                        type: PageTransitionType.bottomToTop),
                                  );
                                } else {
                                  warningText(context,
                                      'Please Verify Your Email', 16.0);
                                }
                              } else {
                                warningText(
                                    context,
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getErrorMessage,
                                    12.0);
                              }
                            });
                          } else {
                            warningText(
                                context, 'Please Check Email/Password', 16.0);
                          }
                        } else {
                          warningText(context, 'Fill All The Data', 16.0);
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<LandingService>(context, listen: false)
                            .forgetPass(context);
                      },
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              decoration: BoxDecoration(
                color: blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.horizontal * 0.3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Name...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: redColor,
                      onPressed: () {
                        if (userEmailController.text.isNotEmpty &&
                            userNameController.text.isNotEmpty &&
                            userPasswordController.text.isNotEmpty) {
                          if (userNameController.text.length < 6 ||
                              userPasswordController.text.length < 6) {
                            warningText(context,
                                'Please Check Your User Name/Password', 16.0);
                          } else if (!RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(userEmailController.text)) {
                            warningText(
                                context, 'Please Check Your Email', 16.0);
                          } else if (Provider.of<Authentication>(context,
                                      listen: false)
                                  .errorMessage !=
                              null) {
                            warningText(
                                context,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .errorMessage,
                                10.0);
                          } else {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(
                                    email: userEmailController.text,
                                    password: userPasswordController.text,
                                    context: context)
                                .then((value) {
                              if (value) {
                                warningText(
                                    context,
                                    'Account Created Successfully !! , Please Verify Your Email ID & Sign In To Proceed ',
                                    16.0);

                                print('Creating Collection');
                                Provider.of<FirebaseNotifier>(context,
                                        listen: false)
                                    .createUserCollection(context, {
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'userEmail': userEmailController.text,
                                  'userName': userNameController.text,
                                  'userImage': Provider.of<LandingUtils>(
                                          context,
                                          listen: false)
                                      .getUserAvatarUrl,
                                  'userPassword': userPasswordController.text,
                                });
                              } else {
                                warningText(
                                    context,
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getErrorMessage,
                                    8.0);
                              }
                            });
                          }
                        } else {
                          warningText(
                              context, 'Please Fill All The Details', 16.0);
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning, double fontsize) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: blueGreyColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  warning,
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: fontsize,
                      fontWeight: FontWeight.bold),
                  maxLines: 5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  forgetPass(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.horizontal * 0.2),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: blueColor,
                      onPressed: () {
                        if (userEmailController.text.isNotEmpty) {
                          if ((RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(userEmailController.text))) {
                            Provider.of<Authentication>(context, listen: false)
                                .forgetPassword(
                                    email: userEmailController.text,
                                    context: context)
                                .then((value) {
                              if (value) {
                                warningText(
                                    context, 'Please Check Your Mail ID', 12.0);
                              } else {
                                warningText(
                                    context,
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getErrorMessage,
                                    12.0);
                              }
                            });
                          } else {
                            warningText(context, 'Invaild Email', 16.0);
                          }
                        } else {
                          warningText(context, 'Fill All The Data', 16.0);
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
            ),
          );
        });
  }
}
