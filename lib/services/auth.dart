import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/services/notification.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        address:
            data["address"] != null ? Address.fromJson(data["address"]) : null,
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
    } on FirebaseAuthException catch (e) {
      //print(e.toString());
      return e;
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
      await userProfileCollection.doc(user.uid).set({
        "token": token,
      }, SetOptions(merge: true));
      return await convertToMyUserType(user);
    } on FirebaseAuthException catch (e) {
      //print(e.toString());
      return e;
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

  //delete account
  Future deleteAccount() async {
    try {
      var currentUser = auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      } else {}
    } catch (e) {
      print(e);
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

  final actionCodeSettings = ActionCodeSettings(
    handleCodeInApp: true, url: '', // Set to true to handle it in-app
  );

  //handle forgotten password
  Future resetPasswordEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }

  Future resetPasswordProper(String newPassword, code) async {
    try {
      await auth.confirmPasswordReset(code: code, newPassword: newPassword);
      return 'success';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }

  Future<Object?> signInWithGoogle() async {
    print("executing this");
    try {
      final googleUser = await GoogleSignIn().signIn();

      final authenticatedUser = await googleUser?.authentication;

      final userCredentials = GoogleAuthProvider.credential(
        accessToken: authenticatedUser?.accessToken,
        idToken: authenticatedUser?.idToken,
      );
      UserCredential result = await auth.signInWithCredential(userCredentials);
      User? user = result.user;
      String? token = await NotificationService().getDeviceToken();
      var profile = await userProfileCollection.doc(user!.uid).get();
      if (!profile.exists) {
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
      } else {
        var data = profile.data() as Map<String, dynamic>;
        if (data["referral code"] == null && data["referral link"] == null) {
          var referralCode = DataBaseService().generateReferralCode();
          var referralLink =
              DataBaseService().generateReferralLink(referralCode);
          await userProfileCollection.doc(user.uid).update(
              {"referral code": referralCode, "referral link": referralLink});
        }
        await userProfileCollection.doc(user.uid).set({
          "token": token,
        }, SetOptions(merge: true));
        return await convertToMyUserType(user);
      }
    } on FirebaseAuthException catch (e) {
      return e;
    } catch (e) {
      print("the google sign in error: $e");
    }
    return null;
  }

  Future linkWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final authenticatedUser = await googleUser?.authentication;

      final userCredentials = GoogleAuthProvider.credential(
        accessToken: authenticatedUser?.accessToken,
        idToken: authenticatedUser?.idToken,
      );

      await auth.currentUser?.linkWithCredential(userCredentials);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error");
      }
    } catch (e) {
      print(e);
    }
  }
}
