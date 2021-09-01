import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userUid;
  String get getUserUid => userUid;
  String errorMessage;

  Future logIntoAccount(
      {@required String email, @required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user;
    userUid = user.uid;
    print(userUid);
    notifyListeners();
  }

  Future createAccount(
      {@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      print('Created Account UID => $userUid');
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code;
    } catch (e) {
      print(e);
    }
  }

  Future logoutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCred.user;
      userUid = user?.uid;
      print('Google User UID => $userUid');
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future signOutWithGoogle() async {
    return GoogleSignIn().signOut();
  }
}
