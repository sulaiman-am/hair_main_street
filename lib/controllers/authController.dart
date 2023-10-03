import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/userModel.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<MyUser?> user = MyUser().obs;

  MyUser? convertToMyUserType(User? user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    user.bindStream(_auth.authStateChanges().map(convertToMyUserType));
    super.onInit();
  }
}
