import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/services/database.dart';

class ReviewController extends GetxController {
  num screenHeight = Get.height;
  RxList<File> imageList = RxList<File>([]);
  var myReviews = [].obs;

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

  //select image from file system
  selectImage() async {
    var images = await DataBaseService().createLocalImages();
    if (images.isNotEmpty) {
      for (File photo in images) {
        imageList.add(photo);
      }
    }
  }

  //upload image
  uploadImage() async {
    var result =
        await DataBaseService().imageUpload(imageList, "review images");
    if (result.isNotEmpty) {
      showMyToast("Photos Added!");
      //downloadUrls.value = result;
    } else {
      showMyToast("Problems Occured while Uploading Photos");
    }
  }

  addAReview(Review review, String productID) async {
    var result = await DataBaseService().addAReview(review, productID);
    print(result);
    if (result == "success") {
      Get.snackbar(
        "Successful",
        "Review Submitted",
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
      Get.back();
    } else {
      Get.snackbar(
        "Error",
        "Review Submission Failed",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: const Color.fromARGB(255, 221, 179, 178),
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  getMyReviews(String userId) {
    myReviews.bindStream(DataBaseService().getUserReviews(userId));
  }
}
