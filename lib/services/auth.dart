import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/services/notification.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection("userProfile");

  MyUser? convertToMyUserType(User? user) {
    return user != null
        ? MyUser(
            uid: user.uid,
            email: user.email,
            // isBuyer: true,
            // isAdmin: false,
            // isVendor: false,
          )
        : null;
  }

// determine the auth state of the app
  Stream<MyUser?> get authState {
    return auth.authStateChanges().map((user) => convertToMyUserType(user));
    //auth.currentUser!.reload();
  }

// register with email and password
  Future createUserWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      dynamic user = result.user;
      await DataBaseService(uid: user.uid).createUserProfile();
      String? token = await NotificationService().getDeviceToken();
      userProfileCollection.doc(user.uid).update({"token": token});
      return convertToMyUserType(user);
    } catch (e) {
      //print(e.toString());
      return e;
    }
  }

  // sign in with email and password
  Future signInWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      dynamic user = result.user;
      String? token = await NotificationService().getDeviceToken();
      userProfileCollection.doc(user.uid).update({"token": token});
      return convertToMyUserType(user);
    } catch (e) {
      //print(e.toString());
      return e;
    }
  }

  //sign out
  Future signOut() async {
    try {
      var userID = auth.currentUser!.uid;
      await auth.signOut();
      userProfileCollection.doc(userID).update({"token": null});
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  //change password
  Future changePassword(String oldPassword, String newPassword) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('No User Signed In');
      }
      final credential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return 'changed Password';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'wrong password';
      }
      print(e);
      return 'an error occurred';
    }
  }

  //handle forgotten password
  Future resetPasswordEmail(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }

  Future restPasswordProper(String newPassword, code) async {
    try {
      return await auth.confirmPasswordReset(
          code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }
}
