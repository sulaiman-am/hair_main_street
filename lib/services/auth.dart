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

  Future<MyUser?> convertToMyUserType(User? user) async {
    if (user == null) {
      return null;
    }
    var otherDetails = await userProfileCollection.doc(user.uid).get();
    if (otherDetails.exists) {
      var data = otherDetails.data() as Map<String, dynamic>;
      return MyUser(
        uid: user.uid,
        email: user.email,
        referralLink: data["referral link"],
        referralCode: data["referral code"],
        isBuyer: data["isBuyer"] ?? true, // Ensure isBuyer has a default value
        phoneNumber: data["phonenumber"],
        isVendor: data["isVendor"],
        fullname: data["fullname"],
        address: data["address"],
        profilePhoto: data["profile photo"],
        // Set other properties here if needed
      );
    } else {
      return null; // Return null if user details don't exist
    }
  }

// Determine the auth state of the app
  Stream<MyUser?> get authState {
    return auth
        .authStateChanges()
        .asyncMap((user) => convertToMyUserType(user));
  }

// register with email and password
  Future createUserWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      dynamic user = result.user;
      await DataBaseService(uid: user.uid).createUserProfile();
      var referralCode = DataBaseService().generateReferralCode();
      var referralLink = DataBaseService().generateReferralLink(referralCode);
      String? token = await NotificationService().getDeviceToken();
      await userProfileCollection.doc(user.uid).update({
        "token": token,
        "referral code": referralCode,
        "referral link": referralLink
      });
      return await convertToMyUserType(user);
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
      User? user = result.user;
      String? token = await NotificationService().getDeviceToken();
      var profile = await userProfileCollection.doc(user!.uid).get();
      var data = profile.data() as Map<String, dynamic>;
      if (data["referral code"] == null && data["referral link"] == null) {
        var referralCode = DataBaseService().generateReferralCode();
        var referralLink = DataBaseService().generateReferralLink(referralCode);
        await userProfileCollection.doc(user.uid).update(
            {"referral code": referralCode, "referral link": referralLink});
      }
      await userProfileCollection.doc(user.uid).update({
        "token": token,
      });
      return await convertToMyUserType(user);
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
