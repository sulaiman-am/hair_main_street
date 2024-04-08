import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    CheckOutController checkOutController = Get.find<CheckOutController>();
    TextEditingController? oldPasswordController,
        newPasswordController = TextEditingController();
    //num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    num screenHeight = MediaQuery.of(context).size.height;

    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Gradient appBarGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 200, 242, 237),
        Color.fromARGB(255, 255, 224, 139)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );

    return GetX<UserController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.white),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          //padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 32),
              color: Colors.black,
              child: Center(
                child: Stack(
                  //alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            blurStyle: BlurStyle.normal,
                            offset: Offset.fromDirection(-4.0),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: screenWidth * 0.28,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 16,
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            )),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProfileLabel(
                hintText: "${userController.userState.value!.fullname}",
                isVisible: true,
                labelText: "Full Name",
                //onPressed: () => showCancelDialog("Full Name"),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProfileLabel(
                hintText: "${userController.userState.value!.address}",
                isVisible: true,
                labelText: "Address",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProfileLabel(
                hintText: "${userController.userState.value!.email}",
                isVisible: false,
                labelText: "Email",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProfileLabel(
                hintText: "${userController.userState.value!.phoneNumber}",
                isVisible: true,
                labelText: "Phone Number",
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          height: screenHeight * 0.13,
          //margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          //decoration: BoxDecoration(color: Color(0xFF9DD9D2)),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      //alignment: Alignment.centerLeft,
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        Form(
                          key: formKey,
                          child: Container(
                            color: Colors.white,
                            height: Get.height * .40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextInputWidget(
                                  labelText: "Old Password",
                                  visibilityIcon: IconButton(
                                    onPressed: () => _.toggle(),
                                    icon: _.isObscure.value
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
                                    oldPasswordController!.text = val!;
                                    return null;
                                  },
                                ),
                                TextInputWidget(
                                  labelText: "New Password",
                                  visibilityIcon: IconButton(
                                    onPressed: () => _.toggle(),
                                    icon: _.isObscure.value
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
                                    } else if (val.length < 6 &&
                                        !validator.isAlphanumeric(val)) {
                                      return "Must be greater than 6 characters &\nmust have letters and numbers";
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    newPasswordController.text = val!;
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.shade300,
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
                                  onPressed: () {
                                    var validated =
                                        formKey.currentState!.validate();
                                    if (validated) {
                                      userController.changePassword(
                                          oldPasswordController!.text,
                                          newPasswordController.text);
                                      userController.isObscure.value = false;
                                      Get.back();
                                    }
                                  },
                                  child: const Text(
                                    "Confirm Change",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.lock,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Change Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      //alignment: Alignment.centerLeft,
                      backgroundColor: Colors.red[400],
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      userController.signOut();
                      checkOutController.checkoutList.clear();
                      Get.offAll(() => HomePage());
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    TextEditingController stateController = TextEditingController();
    showCancelDialog(String text, {String? label}) {
      return Get.dialog(
        Form(
          key: formKey,
          child: Center(
            child: Container(
              height:
                  label == "Address" ? screenHeight * .36 : screenHeight * .24,
              width: screenWidth * .64,
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Edit $text",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  label == "Address"
                      ? Column(
                          children: [
                            TextInputWidgetWithoutLabelForDialog(
                              controller: textController,
                              hintText: "Street Name",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                textController.text = val!;
                                return null;
                              },
                            ),
                            TextInputWidgetWithoutLabelForDialog(
                              controller: stateController,
                              hintText: "State",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                stateController.text = val!;
                                return null;
                              },
                            ),
                          ],
                        )
                      : TextInputWidgetWithoutLabelForDialog(
                          controller: textController,
                          hintText: text,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be Empty";
                            }
                            return null;
                          },
                          textInputType: label == "Phone Number"
                              ? TextInputType.phone
                              : TextInputType.text,
                          onChanged: (val) {
                            textController.text = val!;
                            return null;
                          },
                        ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
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
                    onPressed: () {
                      var validated = formKey.currentState!.validate();
                      if (validated) {
                        String? string;
                        formKey.currentState!.save();
                        if (label == "Address") {
                          string =
                              "${textController.text} ${stateController.text}";
                        } else {
                          string = textController.text;
                        }
                        //print(text.split(" ").join("").toLowerCase());
                        userController.editUserProfile(
                            text.split(" ").join("").toLowerCase(),
                            string.capitalizeFirst);
                        // print(stateController.text);
                        // print("text:${textController.text}");
                        Get.back();
                      }
                    },
                    child: const Text(
                      "Confirm Edit",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Visibility(
              visible: isVisible ?? true,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF392F5A),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    )),
                onPressed: () {
                  switch (labelText!) {
                    case "Full Name":
                      showCancelDialog("Full Name");

                    case "Phone Number":
                      showCancelDialog("Phone Number", label: "Phone Number");

                    case "Address":
                      showCancelDialog("Address", label: "Address");
                    default:
                  }
                },
                icon: const Icon(
                  Symbols.edit_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  "edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                  color: Colors.black26,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
