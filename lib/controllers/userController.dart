import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/referralController.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/services/auth.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  Rx<MyUser?> userState = Rx<MyUser?>(null);
  var isLoading = false.obs;
  var myUser = MyUser().obs;
  var isObscure = true.obs;
  var isImageSelected = false.obs;
  var selectedImage = "".obs;
  Rx<MyUser?> buyerDetails = Rx<MyUser?>(null);
  Rx<Vendors?> vendorDetails = Rx<Vendors?>(null);

  get screenHeight => Get.height;

  @override
  void onInit() {
    ReferralController referralController =
        Get.put<ReferralController>(ReferralController());
    // print(userState.value!.email);
    super.onInit();
    userState.bindStream(determineAuthState());

    ever(userState, (MyUser? newUser) {
      if (newUser != null) {
        referralController.getReferrals();
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
      if (doc != null && doc.exists) {
        // Make sure userState.value is not null
        if (userState.value != null) {
          userState.value!.isVendor = doc.get('isVendor');
          userState.value!.fullname = doc.get('fullname');
        }
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
        return "success";
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
    var result = await DataBaseService().updateUserProfile(fieldName, value);
    userState.update((myUser) {
      myUser!.fullname = result['fullname'];
      myUser.address = result['address'];
      myUser.phoneNumber = result['phoneNumber'];
      myUser.profilePhoto = result['profile photo'];
      // Update other fields if necessary
    });
    return "success";
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

  getVendorDetails(String vendorID) {
    vendorDetails
        .bindStream(DataBaseService().getVendorDetails(userID: vendorID));
    //print(vendorDetails.value);
  }

  void showMyToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // 3 seconds by default, adjust if needed
      gravity: ToastGravity.BOTTOM, // Position at the bottom of the screen
      //timeInSec: 0.3, // Display for 0.3 seconds (300 milliseconds)
      backgroundColor: Colors.white, // Optional: Set background color
      textColor: Colors.black, // Optional: Set text color
      fontSize: 14.0, // Optional: Set font size
    );
  }

  selectProfileImage(ImageSource source, String imagePath) async {
    String? image = await DataBaseService().pickAndSaveImage(source, imagePath);
    if (image != null) {
      isImageSelected.value = true;
      selectedImage.value = image;
      print(selectedImage.value);
    }
  }

  profileUploadImage(List<File> images, String imagePath) async {
    var imageUrl = await DataBaseService().imageUpload(images, imagePath);
    var response = await editUserProfile("profile photo", imageUrl.first);
    print(response);
    if (response == "success") {
      Get.back();
      showMyToast("Image Upload Successful");
    } else {
      showMyToast("Error Uploading\nProfile Image\nTry Again");
    }
  }
}
