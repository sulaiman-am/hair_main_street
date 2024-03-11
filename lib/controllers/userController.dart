import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/services/auth.dart';
import 'package:hair_main_street/services/database.dart';

class UserController extends GetxController {
  Rx<MyUser?> userState = Rx<MyUser?>(null);
  var isLoading = false.obs;
  var myUser = MyUser().obs;
  var isObscure = true.obs;
  Rx<MyUser?> buyerDetails = Rx<MyUser?>(null);

  get screenHeight => Get.height;

  @override
  void onInit() {
    // print(userState.value!.email);
    super.onInit();
    userState.bindStream(determineAuthState());

    ever(userState, (MyUser? newUser) {
      if (newUser != null) {
        getRoleDynamically;
      }
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   if (userState.value != null) {
  //     getRoleDynamically().listen((doc) {
  //       if (doc.exists) {
  //         userState.value!.isVendor = doc.get('isVendor');
  //         print(userState.value!.isVendor);
  //       }
  //     });
  //   }
  // }

  toggle() {
    if (isObscure.value) {
      isObscure.value = false;
    } else {
      isObscure.value = true;
    }
  }

  get getRoleDynamically {
    DataBaseService().getRoleDynamically.listen((doc) {
      if (doc.exists) {
        userState.value!.isVendor = doc.get('isVendor');
        userState.value!.fullname = doc.get('fullname');
      }
    });
  }

  isLoadingState() {
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Timed Out",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[400],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    });
  }

// determine auth user
  Stream<MyUser?> determineAuthState() {
    Stream<MyUser?> stream = AuthService().authState;
    return stream;
  }

  //create user
  createUser(String? email, password) async {
    try {
      var response =
          await AuthService().createUserWithEmailandPassword(email, password);
      if (response is MyUser) {
        myUser.value = response;
        isLoading.value = false;
        Get.snackbar(
          "Success",
          "User Created and Signed In",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.green[200],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.08,
          ),
        );
        Get.offAll(() => HomePage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          response.code.toString().split("_").join(" "),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[400],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.08,
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  // signIn
  dynamic signIn(String? email, String? password) async {
    try {
      var response =
          await AuthService().signInWithEmailandPassword(email, password);
      if (response is MyUser) {
        myUser.value = response;
        isLoading.value = false;
        Get.snackbar(
          "Success",
          "User Signed In",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.green[200],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.08,
          ),
        );
        Get.offAll(() => HomePage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          response.code.toString().split("_").join(" "),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          colorText: Colors.white,
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[700],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.08,
          ),
        );
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      print("hello:${e.toString()}");
    }
  }

  //signOut
  signOut() {
    AuthService().signOut();
    Get.snackbar(
      "Success",
      "User Signed Out",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1, milliseconds: 800),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      backgroundColor: Colors.green[200],
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: screenHeight * 0.08,
      ),
    );
    Get.offAll(() => HomePage());
  }

  //edit user profile
  editUserProfile(String fieldName, value) async {
    var user = await DataBaseService().updateUserProfile(fieldName, value);
    userState.value!.fullname = user['fullname'];
    userState.value!.address = user['address'];
    userState.value!.phoneNumber = user['phoneNumber'];
  }

  changePassword(String oldPassword, String newPassword) async {
    var result = await AuthService().changePassword(oldPassword, newPassword);
    if (result == 'changed Password') {
      Get.snackbar(
        "Success",
        "User Signed Out",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    } else if (result == 'wrong password') {
      Get.snackbar(
        "Error",
        'Wrong Old Password',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        colorText: Colors.white,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[700],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    } else if (result == 'an error occurred') {
      Get.snackbar(
        "Error",
        'An error occurred while changing password',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        colorText: Colors.white,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[700],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  void getBuyerDetails(String userID) async {
    buyerDetails.value = await DataBaseService().getBuyerDetails(userID);
  }

  Future<MyUser?> getUserDetails(String userID) async {
    return await DataBaseService().getBuyerDetails(userID);
  }
}
