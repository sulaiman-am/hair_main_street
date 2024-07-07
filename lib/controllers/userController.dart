import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/notificationController.dart';
import 'package:hair_main_street/controllers/referralController.dart';
import 'package:hair_main_street/models/admin_variable_model.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/services/auth.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recase/recase.dart';

class UserController extends GetxController {
  Rx<MyUser?> userState = Rx<MyUser?>(null);
  Rx<AdminVariableModel?> adminVariables = Rx<AdminVariableModel?>(null);
  var isLoading = false.obs;
  var myUser = MyUser().obs;
  var isObscure = true.obs;
  var isObscure1 = true.obs;
  var isImageSelected = false.obs;
  var selectedImage = "".obs;
  Rx<MyUser?> buyerDetails = Rx<MyUser?>(null);
  Rx<Vendors?> vendorDetails = Rx<Vendors?>(null);
  RxList<Address?> deliveryAddresses = RxList<Address?>([null]);
  RxString error = "".obs;
  RxBool isEditingMode = false.obs;

  get screenHeight => Get.height;

  @override
  void onInit() {
    ReferralController referralController =
        Get.put<ReferralController>(ReferralController());
    // print(userState.value!.email);
    super.onInit();
    userState.bindStream(determineAuthState());
    adminVariables.bindStream(getAdminVariables());

    ever(userState, (MyUser? newUser) {
      if (newUser != null) {
        referralController.getReferrals();
        getRoleDynamically;
      }
    });
  }

  //get delivery addresses
  getDeliveryAddresses(String userID) {
    deliveryAddresses
        .bindStream(DataBaseService().getDeliveryAddresses(userID));
    update();
  }

  //get admin variables
  Stream<AdminVariableModel?> getAdminVariables() {
    return DataBaseService().getAdminVariables();
  }

  //get single address
  Address? getSingleAddress(String addressID) {
    Address? address = deliveryAddresses
        .firstWhere((element) => element!.addressID == addressID);
    return address;
  }

  //add delivery address
  Future<String?> addDeliveryAddress(
      String userID, Address address, bool defaultAddress) async {
    isLoading.value = true;
    var response = await DataBaseService()
        .addDeliveryAddresses(userID, address, defaultAddress);

    if (response == 'success') {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Delivery Address Added",
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
      return 'success';
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "A problem occured while adding delivery address",
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
      return 'failed';
    }
  }

  //edit delivery address
  Future<String?> editDeliveryAddress(
      String userID, Address address, bool defaultAddress) async {
    isLoading.value = true;
    var response = await DataBaseService()
        .editDeliveryAddresses(userID, address, defaultAddress);

    if (response == 'success') {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Delivery Address Edited",
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
      return 'success';
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "A problem occured while editing delivery address",
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
      return 'failed';
    }
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

  toggle1() {
    if (isObscure1.value) {
      isObscure1.value = false;
    } else {
      isObscure1.value = true;
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
        userState.value = response;
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
      if (response is MyUser) {
        userState.value = response;
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
          response.code.toString().split("_").join(" ").titleCase,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[200],
          colorText: Colors.black,
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
        userState.value = response;
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
        error.value = "";
        Get.offAll(() => HomePage());
        Get.find<BottomNavController>().changeTabIndex(0);
      } else {
        isLoading.value = false;
        Get.back();
        Get.snackbar(
          "Error",
          response.code.toString().split("_").join(" ").titleCase,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1, milliseconds: 800),
          colorText: Colors.black,
          forwardAnimationCurve: Curves.decelerate,
          reverseAnimationCurve: Curves.easeOut,
          backgroundColor: Colors.red[200],
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: screenHeight * 0.08,
          ),
        );
        error.value = response.code.toString().split("_").join(" ");
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
    Get.find<BottomNavController>().changeTabIndex(0);
  }

  //delete account
  deleteAccount() {
    AuthService().deleteAccount();
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
  Future<String> editUserProfile(Map<String, dynamic> updatedFields) async {
    var result = await DataBaseService().updateUserProfile(updatedFields);
    if (result["result"] == "success") {
      userState.update((myUser) {
        myUser!.fullname = result['fullname'];
        myUser.address = result['address'] != null
            ? Address.fromJson(result['address'])
            : null;
        myUser.phoneNumber = result['phoneNumber'];
        myUser.profilePhoto = result['profile photo'];
        // Update other fields if necessary
      });
      return "success";
    } else {
      return "error";
    }
  }

  changePassword(String oldPassword, String newPassword) async {
    var result = await AuthService().changePassword(oldPassword, newPassword);
    if (result == 'changed Password') {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Password changed successfully",
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
      Get.close(2);
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
    update();
  }

  Future<MyUser?> getUserDetails(String userID) async {
    return await DataBaseService().getBuyerDetails(userID);
  }

  void getVendorDetails(String vendorID) {
    vendorDetails
        .bindStream(DataBaseService().getVendorDetails(userID: vendorID));
    //print(vendorDetails.value);
  }

  Future<Vendors?> getVendorDetailsFuture(String vendorID) async {
    return await DataBaseService().getVendorDetailsFuture(userID: vendorID);
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

  deleteProfilePicture(String downloadUrl, collection, fieldName, id) async {
    var response = await DataBaseService()
        .deleteImage(downloadUrl, collection, id, fieldName);
    if (response == 'success') {
      isLoading.value = false;
      showMyToast("Image Deleted Successfully");
      Get.close(2);
    } else {
      isLoading.value = false;
      showMyToast("Problem Deleting Image");
      Get.close(1);
    }
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
    Map<String, dynamic> updatedField = {"profile photo": imageUrl.first};
    var response = await editUserProfile(updatedField);
    print(response);
    if (response == "success") {
      Get.back();
      showMyToast("Image Upload Successful");
      selectedImage.value = "";
      isImageSelected.value = false;
    } else {
      showMyToast("Error Uploading\nProfile Image\nTry Again");
    }
  }

  //become a seller
  becomeASeller(Vendors vendor) async {
    isLoading.value = true;
    var result = await DataBaseService().becomeASeller(vendor);
    if (result == 'success') {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
      Get.close(2);
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "A problem occured",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
      Get.close(2);
    }
  }

  sendResetPasswordEmail(String email) async {
    var result = await AuthService().resetPasswordEmail(email);
    if (result == 'success') {
      isLoading.value = false;
      Get.close(1);
      Get.snackbar(
        "Success",
        "Code sent to your email, Kindly check",
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
      return 'success';
    } else if (result.runtimeType == FirebaseAuthException) {
      isLoading.value = false;
      Get.close(1);
      Get.snackbar(
        "Error",
        result.code.toString().split("_").join(" ").titleCase,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        colorText: Colors.black,
        backgroundColor: Colors.red[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
      return 'failed';
    }
  }

  passwordReset(String newPassword, String code) async {
    var result = await AuthService().resetPasswordProper(newPassword, code);
    if (result == 'success') {
      isLoading.value = false;
      Get.close(1);
      Get.snackbar(
        "Success",
        "Password Reset",
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
      return 'success';
    } else if (result.runtimeType == FirebaseAuthException) {
      isLoading.value = false;
      Get.close(1);
      Get.snackbar(
        "Password reset Failed",
        result.code.toString().split("_").join(" ").titleCase,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[200],
        colorText: Colors.black,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
      return 'failed';
    }
  }
}
