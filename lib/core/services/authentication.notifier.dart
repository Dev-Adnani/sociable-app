import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:social_tower/core/services/firebase.notifier.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  final googleLogin = GoogleSignIn();
  String userUid;
  String get getUserUid => userUid;
  String errorMessage;
  String get getErrorMessage => errorMessage;

  Future<bool> forgetPassword(
      {@required String email, @required BuildContext context}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
      return false;
    } on PlatformException catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

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

  Future logout() async {
    await firebaseAuth.signOut();
    await googleLogin.signOut();
    await facebookLogin.logOut();
  }

  Future<bool> signInWithGoogle({@required BuildContext context}) async {
    try {
      final GoogleSignInAccount googleUser = await googleLogin.signIn();
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

  Future<bool> signInWithFacebook({BuildContext context}) async {
    try {
      final response = await facebookLogin.logIn(permissions: [
        FacebookPermission.email,
        FacebookPermission.publicProfile,
      ]);

      final accessToken = response.accessToken;
      final userCredentials = await firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(accessToken.token),
      );

      final User user = userCredentials.user;
      userUid = user.uid;

      Provider.of<FirebaseNotifier>(context, listen: false)
          .createUserCollection(context, {
        'useruid': userUid,
        'userEmail': user.email,
        'userName': user.displayName,
        'userImage': user.photoURL,
        'userPassword': accessToken.token,
      });

      print('Facebook User UID => $userUid');
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
}
