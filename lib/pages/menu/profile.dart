import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/extras/country_state.dart';
import 'package:hair_main_street/models/userModel.dart';

import 'package:hair_main_street/pages/profile/account_information.dart';
import 'package:hair_main_street/pages/profile/delivery_address.dart';
import 'package:hair_main_street/widgets/buttons.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:string_validator/string_validator.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  GlobalKey<FormState> formKey = GlobalKey();

  bool hasUppercaseLetter(String value) {
    RegExp regex = RegExp(r'[A-Z]');
    return regex.hasMatch(value);
  }

  bool hasLowercaseLetter(String value) {
    RegExp regex = RegExp(r'[a-z]');
    return regex.hasMatch(value);
  }

  bool hasNumber(String value) {
    RegExp regex = RegExp(r'[0-9]');
    return regex.hasMatch(value);
  }

  bool hasSpecialCharacters(String value) {
    // Define a regular expression for common special characters
    final regexp = RegExp(r'[!@#$%^&*(),.?\":{}|<>]');
    return regexp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    MyUser user = userController.userState.value!;
    CheckOutController checkOutController = Get.find<CheckOutController>();
    TextEditingController? oldPasswordController,
        newPasswordController = TextEditingController();
    //num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    num screenHeight = MediaQuery.of(context).size.height;
    //print(userController.userState.value!.profilePhoto!);
    String? oldPassword, newPassword;

    showImageUploadDialog() {
      return Get.dialog(
        Obx(() {
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: userController.isImageSelected.value
                  ? screenHeight * 0.80
                  : screenHeight * 0.30,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: userController.isImageSelected.value,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.45,
                            width: screenWidth * 0.70,
                            child: userController.selectedImage.value.isNotEmpty
                                ? Image.file(
                                    File(userController.selectedImage.value),
                                    fit: BoxFit.fill,
                                  )
                                : const Text("Hello"),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await userController.profileUploadImage([
                                    File(userController.selectedImage.value)
                                  ], "profile photo");
                                },
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  userController.selectedImage.value = "";
                                  userController.isImageSelected.value = false;
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await userController.selectProfileImage(
                                  ImageSource.camera, "profile_photo");
                            },
                            child: const Text(
                              "Take Photo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await userController.selectProfileImage(
                                  ImageSource.gallery, "profile_photo");
                            },
                            child: const Text(
                              "Choose From Gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (userController.userState.value!.profilePhoto !=
                              null) {
                            userController.isLoading.value = true;
                            if (userController.isLoading.value) {
                              Get.dialog(const LoadingWidget());
                            }
                            await userController.deleteProfilePicture(
                                userController.userState.value!.profilePhoto!,
                                "userProfile",
                                "profile photo",
                                userController.userState.value!.uid);
                          } else {
                            userController.showMyToast("No Profile Image");
                          }
                        },
                        child: const Text(
                          "Delete Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Get.back();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        barrierColor: Colors.transparent,
        barrierDismissible: true,
      );
    }

    showDeleteAccountDialog() {
      Get.dialog(
        AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
          title: const Text(
            "Delete Account",
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(
            "Are you sure you want to delete your account?",
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.65),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: EdgeInsets.fromLTRB(16, 4, 16, 10),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF673AB7),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFF673AB7),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await userController.deleteAccount();
              },
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }

    return GetX<UserController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 20, color: Colors.black),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: 'Lato',
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        body: ListView(
          //padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: [
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black.withOpacity(0.20),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              color: Colors.white,
              child: Center(
                child: Stack(
                  //alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    userController.userState.value == null ||
                            userController.userState.value!.profilePhoto == null
                        ? const CircleAvatar(
                            radius: 68,
                            backgroundColor: Colors.blue,
                          )
                        : CircleAvatar(
                            radius: 68,
                            //backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              userController.userState.value!.profilePhoto!,
                              scale: 1,
                            ),
                          ),
                    Positioned(
                      bottom: -1,
                      right: 8,
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            )),
                        onPressed: () {
                          showImageUploadDialog();
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 28,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.black.withOpacity(0.20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MenuButton(
                hasIcon: true,
                addedText: user.email,
                text: "Account Information",
                onPressed: () {
                  Get.to(() => const AccountInformationPage());
                },
              ),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black.withOpacity(0.20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MenuButton(
                hasIcon: true,
                text: "Delivery Address",
                onPressed: () {
                  Get.to(() => const DeliveryAddressPage());
                },
              ),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black.withOpacity(0.20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MenuButton(
                text: "Delete Account",
                onPressed: () {
                  showDeleteAccountDialog();
                },
              ),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.black.withOpacity(0.20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Iconify(
                    Mdi.password_outline,
                    size: 24,
                    color: Color(0xFF673AB7),
                  ),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      elevation: 0,
                      Form(
                        key: formKey,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          height: 300,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GetX<UserController>(builder: (controller) {
                                    return TextInputWidget(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      obscureText:
                                          userController.isObscure.value,
                                      labelText: "Old Password",
                                      controller: oldPasswordController,
                                      visibilityIcon: IconButton(
                                        onPressed: () =>
                                            userController.toggle(),
                                        icon: userController.isObscure.value
                                            ? const Icon(
                                                Icons.visibility_off_rounded,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.visibility_rounded,
                                                size: 20,
                                              ),
                                      ),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Cannot be Empty';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        oldPassword = val!;
                                      },
                                    );
                                  }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GetX<UserController>(builder: (controller) {
                                    return TextInputWidget(
                                      obscureText:
                                          userController.isObscure1.value,
                                      labelText: "New Password",
                                      controller: newPasswordController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      visibilityIcon: IconButton(
                                        onPressed: () =>
                                            userController.toggle1(),
                                        icon: userController.isObscure1.value
                                            ? const Icon(
                                                Icons.visibility_off_rounded,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.visibility_rounded,
                                                size: 20,
                                              ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password cannot be empty';
                                        }

                                        // Check if password length is greater than 6
                                        if (!isLength(value, 6)) {
                                          return 'Password must be at least 6 characters long';
                                        }

                                        // Check if password contains at least one uppercase letter
                                        if (hasUppercaseLetter(value) ==
                                            false) {
                                          return 'Password must contain at least one uppercase letter';
                                        }

                                        // Check if password contains at least one lowercase letter
                                        if (!hasLowercaseLetter(value)) {
                                          return 'Password must contain at least one lowercase letter';
                                        }

                                        // Check if password contains at least one digit
                                        if (!hasNumber(value)) {
                                          return 'Password must contain at least one digit';
                                        }

                                        // Check if password contains at least one special character
                                        if (!hasSpecialCharacters(value)) {
                                          return 'Password must contain at least one special character\n!@#\$%^&*(),.?\\":{}|<>';
                                        }

                                        return null;
                                      },
                                      onChanged: (val) {
                                        newPassword = val;
                                      },
                                    );
                                  }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFF673AB7),
                                        padding: const EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        var validated =
                                            formKey.currentState!.validate();
                                        if (validated) {
                                          userController.isLoading.value = true;
                                          if (userController.isLoading.isTrue) {
                                            Get.dialog(const LoadingWidget());
                                          }
                                          userController.changePassword(
                                              oldPassword!, newPassword!);
                                          userController.isObscure.value = true;
                                          userController.isObscure1.value =
                                              true;
                                        }
                                      },
                                      child: const Text(
                                        "Confirm Change",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  label: const Text(
                    "Change Password",
                    style: TextStyle(
                      color: Color(0xFF673AB7),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Raleway',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: ProfileLabel(
            //     hintText: "${userController.userState.value?.fullname}",
            //     isVisible: true,
            //     labelText: "Full Name",
            //     //onPressed: () => showCancelDialog("Full Name"),
            //   ),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: ProfileLabel(
            //     hintText: userController.userState.value!.address == null
            //         ? ""
            //         : "${userController.userState.value?.address!.address!}",
            //     isVisible: true,
            //     labelText: "Address",
            //   ),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: ProfileLabel(
            //     hintText: "${userController.userState.value?.email}",
            //     isVisible: false,
            //     labelText: "Email",
            //   ),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: ProfileLabel(
            //     hintText: "${userController.userState.value?.phoneNumber}",
            //     isVisible: true,
            //     labelText: "Phone Number",
            //   ),
            // ),
            // const SizedBox(
            //   height: 12,
            // ),
          ],
        ),
        // bottomNavigationBar: SafeArea(
        //   child: BottomAppBar(
        //     height: kToolbarHeight,
        //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        //     //height: screenHeight * 0.14,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Expanded(
        //           child: TextButton.icon(
        //             style: TextButton.styleFrom(
        //               padding: EdgeInsets.all(6),
        //               //alignment: Alignment.centerLeft,
        //               backgroundColor: Color(0xFF673AB7),
        //               shape: const RoundedRectangleBorder(
        //                 side: BorderSide(color: Color(0xFF673AB7), width: 2),
        //                 borderRadius: BorderRadius.all(
        //                   Radius.circular(12),
        //                 ),
        //               ),
        //             ),
        //             onPressed: () {
        //               Get.bottomSheet(
        //                 Form(
        //                   key: formKey,
        //                   child: Container(
        //                     color: Colors.white,
        //                     height: Get.height * .40,
        //                     padding: const EdgeInsets.symmetric(
        //                         horizontal: 8, vertical: 4),
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       crossAxisAlignment: CrossAxisAlignment.center,
        //                       children: [
        //                         TextInputWidget(
        //                           labelText: "Old Password",
        //                           visibilityIcon: IconButton(
        //                             onPressed: () => _.toggle(),
        //                             icon: _.isObscure.value
        //                                 ? const Icon(
        //                                     Icons.visibility_off_rounded,
        //                                     size: 20,
        //                                   )
        //                                 : const Icon(
        //                                     Icons.visibility_rounded,
        //                                     size: 20,
        //                                   ),
        //                           ),
        //                           validator: (val) {
        //                             if (val!.isEmpty) {
        //                               return 'Cannot be Empty';
        //                             }
        //                             return null;
        //                           },
        //                           onChanged: (val) {
        //                             oldPasswordController!.text = val!;
        //                           },
        //                         ),
        //                         TextInputWidget(
        //                           labelText: "New Password",
        //                           visibilityIcon: IconButton(
        //                             onPressed: () => _.toggle(),
        //                             icon: _.isObscure.value
        //                                 ? const Icon(
        //                                     Icons.visibility_off_rounded,
        //                                     size: 20,
        //                                   )
        //                                 : const Icon(
        //                                     Icons.visibility_rounded,
        //                                     size: 20,
        //                                   ),
        //                           ),
        //                           validator: (val) {
        //                             if (val!.isEmpty) {
        //                               return 'Cannot be Empty';
        //                             } else if (val.length < 6 &&
        //                                 !validator.isAlphanumeric(val)) {
        //                               return "Must be greater than 6 characters &\nmust have letters and numbers";
        //                             }
        //                             return null;
        //                           },
        //                           onChanged: (val) {
        //                             newPasswordController.text = val!;
        //                           },
        //                         ),
        //                         const SizedBox(
        //                           height: 16,
        //                         ),
        //                         TextButton(
        //                           style: TextButton.styleFrom(
        //                             backgroundColor: Color(0xFF673AB7),
        //                             padding: EdgeInsets.all(6),
        //                             shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(
        //                                 12,
        //                               ),
        //                               side: const BorderSide(
        //                                 width: 2,
        //                                 color: Color(0xFF673AB7),
        //                               ),
        //                             ),
        //                           ),
        //                           onPressed: () {
        //                             var validated =
        //                                 formKey.currentState!.validate();
        //                             if (validated) {
        //                               userController.changePassword(
        //                                   oldPasswordController!.text,
        //                                   newPasswordController.text);
        //                               userController.isObscure.value = false;
        //                               Get.back();
        //                             }
        //                           },
        //                           child: const Text(
        //                             "Confirm Change",
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 15,
        //                               fontFamily: 'Lato',
        //                               fontWeight: FontWeight.w500,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             },
        //             icon: const Icon(
        //               Icons.lock,
        //               size: 20,
        //               color: Colors.white,
        //             ),
        //             label: const Text(
        //               "Change \nPassword",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 15,
        //                 fontWeight: FontWeight.w400,
        //                 fontFamily: 'Lato',
        //               ),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(
        //           width: 4,
        //         ),
        //         Expanded(
        //           child: TextButton(
        //             style: TextButton.styleFrom(
        //               padding: EdgeInsets.all(6),
        //               //alignment: Alignment.centerLeft,
        //               backgroundColor: Color(0xFF673AB7),
        //               shape: const RoundedRectangleBorder(
        //                 side: BorderSide(color: Color(0xFF673AB7), width: 2),
        //                 borderRadius: BorderRadius.all(
        //                   Radius.circular(12),
        //                 ),
        //               ),
        //             ),
        //             onPressed: () {
        //               // userController.signOut();
        //               // checkOutController.checkoutList.clear();
        //               // Get.offAll(() => HomePage());
        //             },
        //             child: const Text(
        //               "Manage Delivery\nAddresses",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 15,
        //                 fontWeight: FontWeight.w400,
        //                 fontFamily: 'Lato',
        //               ),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class ProfileLabel extends StatelessWidget {
  final String? hintText, labelText;
  final bool? isVisible;
  final Function? onPressed;
  ProfileLabel(
      {this.hintText,
      this.isVisible,
      this.labelText,
      this.onPressed,
      super.key});

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    num screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = Get.height;
    TextEditingController textController = TextEditingController();
    TextEditingController streetAddressController = TextEditingController();
    String? country, state, localGovernment, streetAddress;
    CountryAndStatesAndLocalGovernment countryAndStatesAndLocalGovernment =
        CountryAndStatesAndLocalGovernment();
    Widget buildPicker(String label, List<String> items, String? selectedValue,
        Function(String?) onChanged) {
      return Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
              border: const OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isDense: true,
                onChanged: onChanged,
                items: [
                  const DropdownMenuItem(
                    value: 'select',
                    child: Text(
                      'Select',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ...items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // showCancelDialog(String text, {String? label}) {
    //   return Get.dialog(
    //     StatefulBuilder(builder: (context, StateSetter setState) {
    //       return AlertDialog(
    //         contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    //         elevation: 0,
    //         backgroundColor: Colors.white,
    //         scrollable: true,
    //         content: SizedBox(
    //           height: label == "Address"
    //               ? screenHeight * 0.60
    //               : screenHeight * 0.24,
    //           width: screenWidth * 0.64,
    //           child: Form(
    //             key: formKey,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "Edit $text",
    //                   style: const TextStyle(
    //                     fontSize: 20,
    //                     color: Colors.black,
    //                     decoration: TextDecoration.none,
    //                     fontFamily: 'Lato',
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //                 label == "Address"
    //                     ? Column(
    //                         children: [
    //                           SizedBox(
    //                             width: double.infinity,
    //                             child: buildPicker(
    //                                 "Country",
    //                                 countryAndStatesAndLocalGovernment
    //                                     .countryList,
    //                                 country, (val) {
    //                               setState(() {
    //                                 country = val;
    //                               });
    //                             }),
    //                           ),
    //                           buildPicker(
    //                               "State",
    //                               countryAndStatesAndLocalGovernment.statesList,
    //                               state, (val) {
    //                             setState(() {
    //                               state = val;
    //                               localGovernment = null;
    //                             });
    //                           }),
    //                           buildPicker(
    //                               "Local Government",
    //                               countryAndStatesAndLocalGovernment
    //                                       .stateAndLocalGovernments[state] ??
    //                                   [],
    //                               localGovernment ?? "select", (val) {
    //                             setState(() {
    //                               localGovernment = val;
    //                             });
    //                           }),
    //                           TextInputWidgetWithoutLabelForDialog(
    //                             controller: streetAddressController,
    //                             // initialValue: vendorController
    //                             //         .vendor.value!.contactInfo!["street address"] ??
    //                             //     "",
    //                             hintText: "Street Address",
    //                             validator: (val) {
    //                               if (val!.isEmpty) {
    //                                 return "Cannot be Empty";
    //                               }
    //                               return null;
    //                             },
    //                             onChanged: (val) {
    //                               streetAddressController.text = val!;
    //                               streetAddress = streetAddressController.text;
    //                               return null;
    //                             },
    //                           ),
    //                         ],
    //                       )
    //                     : TextInputWidgetWithoutLabelForDialog(
    //                         controller: textController,
    //                         hintText: text,
    //                         validator: (val) {
    //                           if (val!.isEmpty) {
    //                             return "Cannot be Empty";
    //                           }
    //                           return null;
    //                         },
    //                         textInputType: label == "Phone Number"
    //                             ? TextInputType.phone
    //                             : TextInputType.text,
    //                         onChanged: (val) {
    //                           textController.text = val!;
    //                           return null;
    //                         },
    //                       ),
    //                 TextButton(
    //                   style: TextButton.styleFrom(
    //                     backgroundColor: const Color(0xFF673AB7),
    //                     padding: EdgeInsets.all(6),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(
    //                         12,
    //                       ),
    //                       side: const BorderSide(
    //                         width: 2,
    //                         color: Color(0xFF673AB7),
    //                       ),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     var validated = formKey.currentState!.validate();
    //                     if (validated) {
    //                       String? string;
    //                       formKey.currentState!.save();
    //                       if (label == "Address") {
    //                         string =
    //                             "$streetAddress ${localGovernment}LGA $state $country";
    //                       } else {
    //                         string = textController.text;
    //                       }
    //                       userController.editUserProfile(
    //                           text.split(" ").join("").toLowerCase(),
    //                           string.capitalizeFirst);
    //                       Get.back();
    //                     }
    //                   },
    //                   child: const Text(
    //                     "Confirm Edit",
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontFamily: 'Lato',
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }),
    //   );
    // }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText == null ? "label" : labelText!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Visibility(
              visible: isVisible ?? true,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF673AB7), width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    )),
                onPressed: () {
                  // switch (labelText!) {
                  //   case "Full Name":
                  //     showCancelDialog("Full Name");

                  //   case "Phone Number":
                  //     showCancelDialog("Phone Number", label: "Phone Number");

                  //   case "Address":
                  //     showCancelDialog("Address", label: "Address");
                  //   default:
                  // }
                },
                icon: const Icon(
                  Symbols.edit_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  "edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: screenWidth * 0.99,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.normal,
                offset: Offset.fromDirection(-4.0),
                blurRadius: 4,
              ),
            ],
          ),
          child: Obx(
            () {
              var newHint = hintText.obs;
              return Text(
                hintText == null ? "hint" : newHint.value!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
