import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userUid;
  String get getUserUid => userUid;
  String errorMessage;
  String get getErrorMessage => errorMessage;

  Future<bool> logIntoAccount(
      {@required String email,
      @required String password,
      BuildContext context}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      print(userUid);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> createAccount(
      {@required String email,
      @required String password,
      @required BuildContext context}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      print('Created Account UID => $userUid');
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      return false;
    }
  }

  Future logoutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future<bool> signInWithGoogle({@required BuildContext context}) async {
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
      userUid = user.uid;

      Provider.of<FirebaseNotifier>(context, listen: false)
          .createUserCollection(context, {
        'useruid': userUid,
        'userEmail': user.email,
        'userName': user.displayName,
        'userImage': user.photoURL,
        'userPassword': googleAuth.accessToken,
      });

      print('Google User UID => $userUid');
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      return false;
    }
  }

  Future signOutWithGoogle() async {
    return GoogleSignIn().signOut();
  }
}
