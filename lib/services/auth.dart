import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_main_street/services/database.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  MyUser? convertToMyUserType(User? user) {
    return user != null
        ? MyUser(
            uid: user.uid,
            email: user.email,
            isBuyer: true,
            isAdmin: false,
            isVendor: false,
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
      return convertToMyUserType(user);
    } catch (e) {
      //print(e.toString());
      return e;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}
