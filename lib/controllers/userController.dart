import 'package:get/get.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/auth.dart';

class UserController extends GetxController {
  var userState = false.obs;
  var myUser2 = MyUser().obs;

  @override
  void onInit() {
    determineAuthState();
    super.onInit();
  }

// determine auth user
  determineAuthState() async {
    Stream<MyUser?> user = AuthService().authState();
    if (await user.isEmpty) {
      userState.value = false;
    } else {
      userState.value = true;
    }
    //print(myUser);
  }

  //create user
  createUser(String? email, password) {
    myUser2 = AuthService().createUserWithEmailandPassword(email, password)
        as Rx<MyUser>;
  }

  // signIn
  signIn(String? email, String? password) {
    myUser2 =
        AuthService().signInWithEmailandPassword(email, password) as Rx<MyUser>;
  }

  //signOut
  signOut() {
    AuthService().signOut() as Rx<MyUser>;
  }
}
