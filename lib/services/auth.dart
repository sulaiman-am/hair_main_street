import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  MyUser? convertToMyUserType(User? user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

// determine the auth state of the app
  Stream<MyUser?> authState() {
    return _auth.authStateChanges().map((user) => convertToMyUserType(user));
  }

// register with email and password
  Future createUserWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      dynamic user = result.user;
      dynamic userProfile = db.collection("user_profile").doc(user.uid);
      userProfile.set({
        'fullname': "",
        'phonennumber': "",
        'address': "",
      });
      return convertToMyUserType(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign in with email and password
  Future signInWithEmailandPassword(String? email, String? password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

      dynamic user = result.user;
      return convertToMyUserType(user);
    } catch (e) {
      print(e);
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
