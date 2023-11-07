import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    TextEditingController? oldPasswordController,
        newPasswordController = TextEditingController();
    //num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

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

    return GetBuilder<UserController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0E4D92),
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          //decoration: BoxDecoration(gradient: myGradient),
          child: ListView(
            padding: EdgeInsets.only(top: 12),
            children: [
              Center(
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF392F5A),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ProfileLabel(
                hintText: "${userController.userState.value!.fullname}",
                isVisible: true,
                labelText: "Full Name",
                //onPressed: () => showCancelDialog("Full Name"),
              ),
              const SizedBox(
                height: 8,
              ),
              ProfileLabel(
                hintText: "${userController.userState.value!.address}",
                isVisible: true,
                labelText: "Address",
              ),
              const SizedBox(
                height: 8,
              ),
              ProfileLabel(
                hintText: "${userController.userState.value!.email}",
                isVisible: false,
                labelText: "Email",
              ),
              const SizedBox(
                height: 8,
              ),
              ProfileLabel(
                hintText: "${userController.userState.value!.phoneNumber}",
                isVisible: true,
                labelText: "Phone Number",
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                margin: EdgeInsets.only(right: screenWidth * .32),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    //alignment: Alignment.centerLeft,
                    backgroundColor: Color(0xFF392F5A),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      Form(
                        key: formKey,
                        child: Container(
                          height: Get.height * .40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    Symbols.edit_rounded,
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
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(color: Color(0xFF9DD9D2)),
          child: SafeArea(
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
          child: GetX<UserController>(
            builder: (_) {
              return Text(
                hintText == null ? "hint" : hintText!,
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
